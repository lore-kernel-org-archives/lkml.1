Return-Path: <linux-kernel-owner+w=401wt.eu-S1755123AbZECToP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755123AbZECToP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 15:44:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751483AbZECTn7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 15:43:59 -0400
Received: from smtp01.udag.de ([89.31.137.29]:35388 "EHLO smtp01.udag.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751303AbZECTn6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 15:43:58 -0400
X-Greylist: delayed 1066 seconds by postgrey-1.27 at vger.kernel.org; Sun, 03 May 2009 15:43:58 EDT
Message-ID: <49FDEFD1.8020608@nico22.de>
Date: Sun, 03 May 2009 21:26:09 +0200
From: =?ISO-8859-15?Q?Nico_Sch=FCmann?= <spam@nico22.de>
User-Agent: Thunderbird 2.0.0.21 (X11/20090503)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: CFS not suitable for desktop computers
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Linux developers,

I have been using Linux for some years now and for me, the best thing 
about 2.6 was that Linux ran desktop applications just smoothly. I was 
able to compile in the background, while all applications under X11 were 
just usable as if the machine was in idle mode. This was due to the 
priority of gcc being set to 30, for instance.

Then, somewhere around 2.6.19 or 2.6.21, I do not remember exactly, the 
CFS was introduced, which removed all those "latency-based" scheduling 
policies. Now that I use 2.6.29 (I did not write earlier because I 
though it was a regression issue) I have to say: Linux is not as 
perfectly usable as before. End users do not want to experiment with 
nice levels and stuff, they just want that the system stays responsible 
even if there is a cpu-consuming process in the _background_. For me, 
this had been the greatest benefit from using Linux .

Now what can we do, so that foreground applications are smoothly usable 
during hard cpu load? Is there any way to restore the old behaviour that 
cpu-consuming processes get a lower priority? It had always worked until 
this new scheduler was introduced.

Regards,
Nico Schümann
