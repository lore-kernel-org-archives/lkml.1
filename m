Return-Path: <linux-kernel-owner+w=401wt.eu-S1753500AbYLAUk5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500AbYLAUk5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 15:40:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751486AbYLAUks
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 15:40:48 -0500
Received: from outbound-mail-128.bluehost.com ([67.222.38.28]:53864 "HELO
	outbound-mail-128.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751899AbYLAUkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 15:40:47 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=R/O65ye/wk5TZkfS8e9DGEwf5RqyGECtFIngy8NBFOJlHOaF17nDlfwtNWUiNNQ+7jHn1PIPw/eJ19WvfIkOFpBLUI2v0RTGfI8BTIyNcAj66IfPW0PUvxKGFQoyhjai;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH (resend)] acpiphp: Identify more removable slots
Date: Mon, 1 Dec 2008 12:40:45 -0800
User-Agent: KMail/1.10.1 (Linux/2.6.27.5-41.fc9.x86_64; KDE/4.1.2; x86_64; ; )
Cc: linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, kristen.c.accardi@intel.com
References: <20081113235255.GA17709@srcf.ucam.org> <20081117134952.GA12932@srcf.ucam.org> <20081125214814.GA17248@srcf.ucam.org>
In-Reply-To: <20081125214814.GA17248@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812011240.45795.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, November 25, 2008 1:48 pm Matthew Garrett wrote:
> According to section 6.3.6 of the ACPI spec, the presence of an _RMV
> method that evaluates to 1 is sufficient to indicate that a slot is
> removable without needing an eject method. This patch refactors the
> ejectable slot detection code a little in order to flag these slots as
> ejectable and register them. Acpihp then binds to the expresscard slot
> on my HP test machine.
>
> Signed-off-by: Matthew Garrett <mjg@redhat.com>

Applied to my linux-next branch, thanks Matthew.

-- 
Jesse Barnes, Intel Open Source Technology Center

