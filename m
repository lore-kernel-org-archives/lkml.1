Return-Path: <linux-kernel-owner+w=401wt.eu-S1753012AbYCOPsB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753012AbYCOPsB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2008 11:48:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751842AbYCOPrw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Mar 2008 11:47:52 -0400
Received: from web52510.mail.re2.yahoo.com ([206.190.48.193]:39897 "HELO
	web52510.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751831AbYCOPrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2008 11:47:52 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=2YM5UBxWbulYI8uLz7YnEuEiN9u0Okt321Fl2+8ANf1DbcyaHn95RCi4dZkOUzEi/31qnObAI6jJD9QC8G46LQ/Vqi7qX+N/8t9RaTP2+viaQE1YkFedufdBL7D7zebfEMywT4pdbFlVqxFtEAekiPkLSSrKWCLLGZu+T+CGF9w=;
X-YMail-OSG: PQDQtrwVM1l14GFDABHmBEENojVjHGPTgFiufEKhdyFj4Jp4tRIK2P3mhZ41gdp1zzz7y0BX6AsjasfrifhvjHrF1zXj7zVuUt36lbcWAZc8_gUyLMU-
Date: Sat, 15 Mar 2008 08:47:47 -0700 (PDT)
From: Marc Perkel <mperkel@yahoo.com>
Subject: TCP stack optimization for high number of connections [OT]
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <873209.1586.qm@web52510.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm running a front end spam filtering service and I
get a lot of incoming connections but not a lot of
volume of traffic. I'm experiencing some high loads
and I think it might be related to the volume of
connections it's processing. I often will be connected
to 2500 email servers at once and a lot more that are
trying to connect and being denied.

My question - are there any optimizations I can do to
make the TCP faster for high number of short lived
connections?

Also - how much do iptable entries slow things down
and is there any optimizations for that?


Marc Perkel
Junk Email Filter dot com
http://www.junkemailfilter.com


      ____________________________________________________________________________________
Never miss a thing.  Make Yahoo your home page. 
http://www.yahoo.com/r/hs
