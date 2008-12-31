Return-Path: <linux-kernel-owner+w=401wt.eu-S1756663AbYLaUPw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756663AbYLaUPw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 15:15:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757140AbYLaUPZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 15:15:25 -0500
Received: from outbound-mail-317.bluehost.com ([67.222.54.10]:56119 "HELO
	outbound-mail-317.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757090AbYLaUPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 15:15:22 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=NyIFTROY+x/AIBYRtKqJDMUyw3Zwg7cUnA7pXH98c9hiubUkQbnSUzCTAsu0z0ElSJ5sKMdfGk7SzXCmtxtx+YqrOZFK3WVQcHsLFLtVdEfcqxhrmuUOmGgb3+CHYplw;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH 1/2] PCI PM: Split PCI Express port suspend-resume
Date: Wed, 31 Dec 2008 12:08:40 -0800
User-Agent: KMail/1.10.1 (Linux/2.6.27.5-41.fc9.x86_64; KDE/4.1.3; x86_64; ; )
Cc: pm list <linux-pm@lists.linux-foundation.org>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <200812271627.32781.rjw@sisk.pl> <200812271628.58748.rjw@sisk.pl>
In-Reply-To: <200812271628.58748.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812311208.41424.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, December 27, 2008 7:28 am Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
>
> Suspend-resume of PCI Express ports has recently been moved into
> _suspend_late() and _resume_early() callbacks, but some functions
> executed from there should not be called with interrupts disabled,
> eg. pci_enable_device().  For this reason, split the suspend-resume
> of PCI Express ports into parts to be executed with interrupts
> disabled and with interrupts enabled.

Applied both of these, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center

