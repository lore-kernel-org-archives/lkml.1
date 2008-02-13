Return-Path: <linux-kernel-owner+w=401wt.eu-S1756547AbYBMOCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756547AbYBMOCV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 09:02:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752873AbYBMOCK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 09:02:10 -0500
Received: from py-out-1112.google.com ([64.233.166.176]:58659 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752520AbYBMOCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 09:02:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=M8obVfhCiYfAXzkOtJura0OlT6y2gfTLocpF71RnfPXQuQcQB9A6o53q4mRv3j995+g7hZzS1MygnHs6dwJvI4Fg5SJgR8pOFHZDQMvUIjF8r8BwNzt/ixhQKs64b1xMjw+8Kt/EoaRgfl6vwIPyyovgTRPykE5CTGXwx1RmyXo=
Message-ID: <38b2ab8a0802130602r7d8fc470i7896e406d0451ec7@mail.gmail.com>
Date: Wed, 13 Feb 2008 15:02:08 +0100
From: "Francis Moreau" <francis.moro@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Question on timekeeping subsystem
Cc: johnstul@us.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I looked at this subsystem, trying to understand how this works on Linux
but call me a dumb xxx but I think I really miss something.

First I tried to find some documentation on the current implementation
but haven't found any thing really usefull. Specially there's nothing about
it in Documentation/ directory. Please correct me if I'm already wrong.

Actually I read the implementation of update_wall_time() and I really fail
to understand how it works. This is probably because I don't know
what "xtime_nsec" and "error" fields in clocksource struct are for.
These fields are not documented anywhere in the source code so it
should be obvious but unfortunately not for me.

Another example almost the first thing done by this function is:

    clock->xtime_nsec += (s64)xtime.tv_nsec << clock->shift;

What's the hell this ?

I know I'm stupid but please enlight me ;)

Thanks
-- 
Francis
