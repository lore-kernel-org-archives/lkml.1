Return-Path: <linux-kernel-owner+w=401wt.eu-S1762786AbYJKTFU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762786AbYJKTFU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 15:05:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762432AbYJKTFH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 15:05:07 -0400
Received: from web38204.mail.mud.yahoo.com ([209.191.124.147]:28275 "HELO
	web38204.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759469AbYJKTFG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 15:05:06 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=cEDLBTSsAHhSGDV4lkmxxpdUc/qqMuek5IR3pVeaYBzULfEYPjJFsCpyfjmNa9xPVEE9BZpYIj6YcO5oEW1/ebuKR4NUwibgf0pw2WRC6JwH0ypKc/6nZU891TC+GFpr1ucUn9ArEzj+t87wizIlyipgAOG/v3OmKvxl3dbQ+/E=;
X-YMail-OSG: NKuCtXcVM1lH7ATlogZLQcnS2Ep1Pq32PM1ejnf33Q1rzYUWnSdgjMwDkeEMaiz6RsERM9whfm5jH6.85i1sRcOgVCF04F17XywxfzkTKvqvCASkd5RM_Ta9t.UfunluBm7d3muj.wvHkhlI8TESKKxQlL20IMHJVKuZh4rbXmILRA--
X-Mailer: YahooMailRC/1096.40 YahooMailWebService/0.7.218.2
Date: Sat, 11 Oct 2008 12:05:05 -0700 (PDT)
From: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: Re: Help text for config OPTIMIZE_INLINING
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Message-ID: <251184.8738.qm@web38204.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Ingo Molnar <mingo@elte.hu>

> 
> * Sitsofe Wheeler wrote:
>  
> > While [this] suggests that one should set it to y to generate smaller 
> > kernels. My own experience says that setting it to y DOES generate a 
> > smaller kernel so perhaps the main text should be changed to reflect 
> > this?
> 
> sure, could you send a patch (with lkml Cc:-ed) that does this?

Will do (I won't send it via Yahoo mail though because it will be mangled).

> Also, would be nice if you sent with/without vmlinux size numbers for 
> the config you are using. Btw., do you have 

5463127 2008-10-11 19:51 vmlinux.no-opt
5456152 2008-10-11 19:56 vmlinux.opt

So about 6975 bytes smaller. This is a config which is vastly cut down, compiler was gcc version 4.1.2 20070925 (Red Hat 4.1.2-33) on Fedora 8.

> CONFIG_CC_OPTIMIZE_FOR_SIZE=y enabled as well? That too shrinks the 
> kernel (which speeds it up as well on moder CPUs), quite visibly.

In the past I've tried it out but it seemed to make my crude benchmark (glxgears) go slower...



      
