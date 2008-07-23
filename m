Return-Path: <linux-kernel-owner+w=401wt.eu-S1755559AbYGXABz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559AbYGXABz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 20:01:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752146AbYGXABt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 20:01:49 -0400
Received: from web50202.mail.re2.yahoo.com ([206.190.38.43]:47582 "HELO
	web50202.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751025AbYGXABs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 20:01:48 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 Jul 2008 20:01:48 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Message-ID;
  b=I8iH4Kicr1sy9akwbBvxFvIURmbwBG5BQg2psSnu3ygW5SfeaOXcQPWTJmbx/MgCKCXhdch5xNQmpaaPxvQfKmXFW0saFv+oRHTDFgi7UyIBWIngSnjf2Ttn1XO+6q0yHizBHi4Y+k5lY/PYo9OVPKsTaX4xQ4x22fh8FopoGXY=;
X-Mailer: YahooMailWebService/0.7.218
Date: Wed, 23 Jul 2008 16:55:06 -0700 (PDT)
From: Alex Davis <alex14641@yahoo.com>
Reply-To: alex14641@yahoo.com
Subject: Possible coding error in ./drivers/net/wan/dlci.c
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080723191443.GT10471@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <127008.37767.qm@web50202.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the 2.6.25.10 version of this file, function dlci_del, the function __dev_get_by_name is called with neither the RTNL semaphore or dev_base_lock being held. According to the documentation for __dev_get_by_name, one of the aforementioned locks must be held. Am I missing something?


I code, therefore I am


      
