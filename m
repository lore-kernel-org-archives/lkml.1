Return-Path: <linux-kernel-owner+w=401wt.eu-S1756611AbYLAAWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756611AbYLAAWS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2008 19:22:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753457AbYLAAWK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Nov 2008 19:22:10 -0500
Received: from s15216962.onlinehome-server.info ([217.160.22.205]:39797 "EHLO
	s15216962.onlinehome-server.info" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752627AbYLAAWJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2008 19:22:09 -0500
Date: Mon, 1 Dec 2008 01:19:13 +0100
From: Enrico Weigelt <weigelt@metux.de>
To: linux kernel list <linux-kernel@vger.kernel.org>
Subject: Re: Developing non-commercial drivers ?
Message-ID: <20081201001913.GA28673@nibiru.local>
Reply-To: weigelt@metux.de
References: <fc262dee0811180816k29cc93aas51c2c47ede2c7a1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <fc262dee0811180816k29cc93aas51c2c47ede2c7a1@mail.gmail.com>
User-Agent: Mutt/1.4.1i
X-Terror: bin laden, kill bush, Briefbombe, Massenvernichtung, KZ, 
X-Nazi: Weisse Rasse, Hitlers Wiederauferstehung, 42, 
X-Antichrist: weg mit schaeuble, ausrotten, heiliger krieg, al quaida, 
X-Killer: 23, endloesung, Weltuntergang, 
X-Doof: wer das liest ist doof
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Fredrik Markström <fredrik.markstrom@avalonenterprise.com> wrote:

Hi,

> I'm working for as a consultant for a large hardware company porting
> Linux to their new cpu-architecture and everything is pretty much
> up and running. Now they want us to develop a closed-source (to
> protect their IP) ethernet driver for their proprietary Ethernet MAC.

Much of this already had been answered, but just to summarize:

* technically, binary drivers are a very bad idea - just look at 
  the utterly broken nv crap. 
* IMHO, as soon as you include some kernel-internal headers, you've
  got an derived work, thus violating GPL (IANAL!)
* binary-only drivers DON NOT protect IP, just delay the process 
  of revealing a little bit.
* try to find out whether the customer *really* has some valueble 
  IP to protect or if it's just it's default oppionion
* *if* the customer still wants an binary-only driver, you check 
  whether the logic to hide can be moved to userland (let the userland
  part talk to the in-kernel driver via 9P)
* let your customer know that binary-only drivers tend to heavily 
  damage a company's reputation in the OSS world, *BAD* for marketing.
    

just my 0.02,-


cu
-- 
---------------------------------------------------------------------
 Enrico Weigelt    ==   metux IT service - http://www.metux.de/
---------------------------------------------------------------------
 Please visit the OpenSource QM Taskforce:
 	http://wiki.metux.de/public/OpenSource_QM_Taskforce
 Patches / Fixes for a lot dozens of packages in dozens of versions:
	http://patches.metux.de/
---------------------------------------------------------------------
