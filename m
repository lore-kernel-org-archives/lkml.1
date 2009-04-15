Return-Path: <linux-kernel-owner+w=401wt.eu-S1758510AbZDOGnp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758510AbZDOGnp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 02:43:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752647AbZDOGnf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 02:43:35 -0400
Received: from e28smtp08.in.ibm.com ([59.145.155.8]:46654 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052AbZDOGne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 02:43:34 -0400
Message-ID: <49E58211.6040900@in.ibm.com>
Date: Wed, 15 Apr 2009 12:13:29 +0530
From: Sachin Sant <sachinp@in.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081216)
MIME-Version: 1.0
To: linux-s390@vger.kernel.org
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Next April 15: s390 allnoconfig build failure
References: <20090415144745.c4fb5c4b.sfr@canb.auug.org.au>
In-Reply-To: <20090415144745.c4fb5c4b.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Today's next tree build (s390 allnoconfig) failed with

arch/s390/kernel/ipl.c: In function 'stop_run':
arch/s390/kernel/ipl.c:1461: error: implicit declaration of function 
'signal_processor'
arch/s390/kernel/ipl.c:1461: error: 'sigp_stop' undeclared (first use in 
this function)
arch/s390/kernel/ipl.c:1461: error: (Each undeclared identifier is 
reported only once
arch/s390/kernel/ipl.c:1461: error: for each function it appears in.)
make[1]: *** [arch/s390/kernel/ipl.o] Error 1

Thanks
-Sachin


-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------

