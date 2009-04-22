Return-Path: <linux-kernel-owner+w=401wt.eu-S1755337AbZDVIMK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337AbZDVIMK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 04:12:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753065AbZDVILx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 04:11:53 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:37470 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752406AbZDVILw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 04:11:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:mail-followup-to
         :references:mime-version:content-type:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        b=BE7WItw3ExTTCsLojwxxtFnI9OSJowvYkgPIgLfc220nSoy82zklkI2sPjbV0HCra+
         fW2hqv3zh/I9a9N1GU3HhlsbSFWgcUAOBq6XJrwKXUkmy2FpOJRGsE2BaaCczTDMKwol
         SuF3BUtemDrBzEwxrwPlt16kqN4WkfJGkb0G4=
Date: Wed, 22 Apr 2009 10:11:45 +0200
From: Borislav Petkov <petkovbb@googlemail.com>
To: Ozan =?utf-8?B?w4dhxJ9sYXlhbg==?= <ozan@pardus.org.tr>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [BUG 2.6.30_rc1] powernow-k8: oops during initialization
Message-ID: <20090422081145.GA23984@liondog.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com,
	Ozan =?utf-8?B?w4dhxJ9sYXlhbg==?= <ozan@pardus.org.tr>,
	linux-kernel@vger.kernel.org
References: <49E7175D.6060808@pardus.org.tr> <20090422073833.GA23936@liondog.tnic> <49EECC96.7050407@pardus.org.tr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <49EECC96.7050407@pardus.org.tr>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 22, 2009 at 10:51:50AM +0300, Ozan Çağlayan wrote:
> Borislav Petkov wrote On 22-04-2009 10:38:
> > BIOS is missing the _PSS objects on which powernow-k8 relies. I'm pretty
> > sure you had similar message in earlier kernels but it was a simple
> > warning then.
> >
> > Is it possible to upgrade your BIOS? If you're lucky, it might've been
> > fixed :).
> >   
> > Just read what the message says: it is not a kernel bug but simply your
> 
> Yes I'm aware about the firmware bug but the backtrace shouldn't appear
> on the kernel log buffer,

Why not?

For the reasoning behind why you get a backtrace instead of simple
warning see

79cc56af9fdbeaa91f50289b932d0959b41f9467
a0ad05c75aa362c91f4d9cd91ff375a739574dd8

-- 
Regards/Gruss,
    Boris.
