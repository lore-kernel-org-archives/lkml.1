Return-Path: <linux-kernel-owner+w=401wt.eu-S1753046AbXLITDn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753046AbXLITDn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 14:03:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751054AbXLITDg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 14:03:36 -0500
Received: from nf-out-0910.google.com ([64.233.182.185]:10868 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940AbXLITDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 14:03:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=WG+UngbI5dQLMt90yFsT0TFaFBIqjhG/hqH5Obs6yVg4ZxHIKyaPMMBKU6M81pmuixiAJmveD4EK7r64UkKiUsNEpuIa6/lpZ++ktv6aERdQpN+Wg4cjwke/WQfimcu+mAbpArb2Up05pEunewhqgINT11RJtZot+rbcp+Hrt3g=
Message-ID: <2c0942db0712091103w1d50f58br4c14f19a79c4df36@mail.gmail.com>
Date: Sun, 9 Dec 2007 11:03:33 -0800
From: "Ray Lee" <ray-lk@madrabbit.org>
To: Markus <M4rkusXXL@web.de>
Subject: Re: programs vanish with 2.6.22+
Cc: linux-kernel@vger.kernel.org,
       "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>
In-Reply-To: <200712081325.21790.M4rkusXXL@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200712061906.42070.M4rkusXXL@web.de>
	 <200712072352.04454.M4rkusXXL@web.de>
	 <Pine.LNX.4.64.0712080043360.847@axis700.grange>
	 <200712081325.21790.M4rkusXXL@web.de>
X-Google-Sender-Auth: 3918edec65926d48
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 8, 2007 4:25 AM, Markus <M4rkusXXL@web.de> wrote:
> Well, just tried it. Started a dozen konquerors and attached strace to
> everyone. When one disapeared, I only got a "Process 9246 detached",
> nothing else is printed or written in the log.

You could try an ltrace instead, and see if it's one of the linked
libraries having a problem.
