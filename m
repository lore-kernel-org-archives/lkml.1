Return-Path: <linux-kernel-owner+w=401wt.eu-S1751270AbZGLEVl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751270AbZGLEVl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 00:21:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750818AbZGLEV3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 00:21:29 -0400
Received: from l2mail1.panix.com ([166.84.1.75]:55282 "EHLO l2mail1.panix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750800AbZGLEV2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 00:21:28 -0400
X-Greylist: delayed 1135 seconds by postgrey-1.27 at vger.kernel.org; Sun, 12 Jul 2009 00:21:27 EDT
Date: Sat, 11 Jul 2009 21:02:30 -0700 (PDT)
From: Kenneth Crudup <kenny@panix.com>
To: haiyang kang <cornsea@gmail.com>
cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-laptop@vger.kernel.org
Subject: Re: sometimes kernel cannot detect GlidePoint input Device
In-Reply-To: <62c294d80907112005n6458193dye48d5bd3203d50f4@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0907112100480.9685@hp9800.localdomain>
References: <62c294d80907112005n6458193dye48d5bd3203d50f4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I had this problem once; try putting

  i8042.noloop=1

... in your kernel command line.

	-Kenny

-- 
Kenneth R. Crudup  Sr. SW Engineer, Scott County Consulting, Los Angeles
O: 3630 S. Sepulveda Blvd. #138, L.A., CA 90034-6809      (888) 454-8181
