Return-Path: <linux-kernel-owner+w=401wt.eu-S1752983AbYE1QeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752983AbYE1QeV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 12:34:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751749AbYE1QeF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 12:34:05 -0400
Received: from el-out-1112.google.com ([209.85.162.179]:9248 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628AbYE1QeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 12:34:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=O6L4Ppjuv8iTzRZnZhccYi+Ft7u1Zang6JpkyTxFPNKyyo/ehsHNTPBttIeIUZgQTv+5kNrbaCGSgsNJFBIgbnFeSZtBEROTjiOUp1kmkHWGvZHGTLpsnDhDcf/Z47FGQnPHEF0wwPk+PC5rw6hYBslqVHaS4Ux8CmXkSHQq3+E=
Message-ID: <95711f160805280934y77ed7d91tec5aeb531bf8013c@mail.gmail.com>
Date: Wed, 28 May 2008 18:34:00 +0200
From: "=?ISO-8859-1?Q?Jens_B=E4ckman?=" <jens.backman@gmail.com>
To: "Justin Piszcz" <jpiszcz@lucidpixels.com>
Subject: Re: Performance Characteristics of All Linux RAIDs (mdadm/bonnie++)
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com
In-Reply-To: <alpine.DEB.1.10.0805280442330.4527@p34.internal.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.DEB.1.10.0805280442330.4527@p34.internal.lan>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2008 at 10:53 AM, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
> Results:
>
> http://home.comcast.net/~jpiszcz/raid/20080528/raid-levels.html
> http://home.comcast.net/~jpiszcz/raid/20080528/raid-levels.txt

Either the RAID 1 read speed must be wrong, or something is odd in the
Linux implementation. There's six drives that can be used for reading
at the same time, as they contain the very same data. 63MB/s
sequential looks like what you would get from a single drive.
