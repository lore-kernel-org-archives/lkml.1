Return-Path: <linux-kernel-owner+w=401wt.eu-S936994AbXG0MH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936994AbXG0MH3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 08:07:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932286AbXG0MHS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 08:07:18 -0400
Received: from wx-out-0506.google.com ([66.249.82.229]:4716 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765178AbXG0MHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 08:07:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=BQ2hjcr0bQ39CO4eLbGG8tCiOfJsm/fAe3hYSZVWDeREx/WBFMY7b2d8IunAznUkiSDtMzRNZPReJ0OvqfeB+xLFvhNQ0rk3keKvth/KN6YODC/D1cJK4YWI2gL+krZS0uVhUwXp5+VXuzc6DSHagUs1cMTX8iBpwnM35BG6IE8=
Message-ID: <b6fcc0a0707270507u1c77e093y30d9bd5bddfa9054@mail.gmail.com>
Date: Fri, 27 Jul 2007 16:07:13 +0400
From: "Alexey Dobriyan" <adobriyan@gmail.com>
To: "Jan Engelhardt" <jengelh@computergmbh.de>
Subject: Re: [PATCH 02/68] 0 -> NULL, for arch/arm
Cc: "Al Viro" <viro@ftp.linux.org.uk>, "Yoann Padioleau" <padator@wanadoo.fr>,
       kernel-janitors@vger.kernel.org, rmk@arm.linux.org.uk,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0707271250020.12711@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200707270944.LAA17082@ifs.emn.fr>
	 <20070727095905.GU27237@ftp.linux.org.uk>
	 <Pine.LNX.4.64.0707271250020.12711@fbirervta.pbzchgretzou.qr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/27/07, Jan Engelhardt <jengelh@computergmbh.de> wrote:
>
> On Jul 27 2007 10:59, Al Viro wrote:
> >On Fri, Jul 27, 2007 at 11:44:07AM +0200, Yoann Padioleau wrote:
> >>  		buf = alloc_safe_buffer(device_info, ptr, size, dir);
> >> -		if (buf == 0) {
> >> +		if (buf == NULL) {
> >
> >		if (!buf)
> >surely...
>
> Makes it look like it's used as a bool.

bool variables are rarely named buf, so no.
