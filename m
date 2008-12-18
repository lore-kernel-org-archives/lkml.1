Return-Path: <linux-kernel-owner+w=401wt.eu-S1754543AbYLRXkp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543AbYLRXkp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2008 18:40:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752718AbYLRXkS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 18:40:18 -0500
Received: from outbound-mail-104.bluehost.com ([69.89.22.14]:58931 "HELO
	outbound-mail-104.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752681AbYLRXkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 18:40:16 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=lyj+LUDv6re78RQucePvbxJ+9YqlWVd/IXEt1BZDgu2dcGmaR5URoSW7j/UyhYWhsv5ei7UpPqOtLa52n0l0r8v8yU11obZVXlH76EB6mGiBDEHPdagnPanqYpI4qTxC;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: dri-devel@lists.sourceforge.net
Subject: Re: [PATCH 6/6] drm/i915: add prototype for 'intelfb_panic' to header file
Date: Thu, 18 Dec 2008 15:40:07 -0800
User-Agent: KMail/1.10.1 (Linux/2.6.27.5-41.fc9.x86_64; KDE/4.1.3; x86_64; ; )
Cc: Hannes Eder <hannes@hanneseder.net>, David Airlie <airlied@linux.ie>,
       kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <494ad5e4.0baa660a.04de.7bb4@mx.google.com>
In-Reply-To: <494ad5e4.0baa660a.04de.7bb4@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812181540.08366.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, December 18, 2008 1:32 pm Hannes Eder wrote:
> Fix this sparse warning:
>
>   drivers/gpu/drm/i915/intel_fb.c:417:5: warning: symbol 'intelfb_panic'
> was not declared. Should it be static?

Yep, this one should be static instead (I think, just double checking now to 
make sure it's not used elsewhere, iirc it's not).

-- 
Jesse Barnes, Intel Open Source Technology Center

