Return-Path: <linux-kernel-owner+w=401wt.eu-S932536AbXCRRsi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932536AbXCRRsi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 13:48:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932583AbXCRRsh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 13:48:37 -0400
Received: from smtp113.sbc.mail.mud.yahoo.com ([68.142.198.212]:25209 "HELO
	smtp113.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932536AbXCRRsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 13:48:36 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Sun, 18 Mar 2007 13:48:36 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=sbcglobal.net;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:Content-Type;
  b=T/N/tjysnzZgYfcWgTZQIK84hny2nSWNfb+l4u5QFJpipN4jeRgRgdx77HAhMeJhupSeY0a2+WFjN2TYcrP/+/mZFABDPLMKAXl3QX5KnGCxzTvX2EQO4+9ejIJ/3lW4bUUMGmm28RvdwVrlRThqcbLfzYT0WGBrGS62F91t0do=  ;
X-YMail-OSG: HbBOrr4VM1kwM0.B_Y0WxcBA5ooDGr26XJH9unh3xAqymAsyrDmrTQo7sp1r2sFJ5a.bCytCsEtBhzfr8GZX.vpcBJAF.Pe2uESPMdt1CNVyJVL0qVXp
Message-ID: <45FD79E3.5050004@sbcglobal.net>
Date: Sun, 18 Mar 2007 10:41:55 -0700
From: Bryan Batten <BryanBatten@sbcglobal.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.13) Gecko/20060417
X-Accept-Language: en-us, en, es, fr, el, ja, zh
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: "Carl-Daniel Hailfinger@sbcglobal.net" 
	<c-d.hailfinger.kernel.2004@gmx.net>
Subject: kmalloc oops
Content-Type: multipart/mixed;
 boundary="------------040300050501090807080701"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040300050501090807080701
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

I'm working on a driver which currently is a real memory hog. As a 
result, it seems to stress other system components, one of which seems 
to be the forcedeth ethernet driver.

The attached file has the oops trace that was recently generated. I 
thought you might be interested in taking a look.

-- 
Bryan

----------------------------------------------------------------------
"You're tensing up, Arthur! The trick is to leap *before* you look!"

The Tick, ca. 1995
----------------------------------------------------------------------


--------------040300050501090807080701
Content-Type: text/plain;
 name="forcedeth.oops"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="forcedeth.oops"

ksymoops 2.4.9 on i686 2.4.34.  Options used
     -V (default)
     -k /var/log/ksymoops/20070317111830.ksyms (specified)
     -l /var/log/ksymoops/20070317111830.modules (specified)
     -o /lib/modules/2.4.34/ (default)
     -m /boot/System.map-2.4.34 (default)



Adhoc c01380d0 <__wait_on_buffer+50/80>
Adhoc c0138362 <wait_for_buffers+82/90>
Adhoc c0138393 <wait_for_locked_buffers+23/40>
Adhoc c0138415 <sync_buffers+65/70>
Adhoc c0138565 <fsync_dev+55/60>
Adhoc c01a8eb9 <go_sync+169/170>
Adhoc c01a8f82 <do_emergency_sync+c2/d0>
Adhoc c01178d3 <panic+113/130>
Adhoc c011acf0 <do_exit+240/260>
Adhoc c0114090 <do_page_fault+0/577>
Adhoc c01075b2 <die+72/80>
Adhoc c01143a5 <do_page_fault+315/577>
Adhoc c022eae0 <nf_hook_slow+b0/170>
Adhoc c02375fc <ip_local_deliver+1ac/1e0>
Adhoc c0237a00 <ip_local_deliver_finish+0/180>
Adhoc c0237d29 <ip_rcv_finish+1a9/200>
Adhoc c0237b80 <ip_rcv_finish+0/200>
Adhoc c0114090 <do_page_fault+0/577>
Adhoc c0107004 <error_code+34/3c>
Adhoc c012eb14 <kmalloc+b4/120>
Adhoc c0226149 <netif_rx+79/170>
Adhoc c0222011 <alloc_skb+b1/1c0>
Adhoc e088c7df <[forcedeth]nv_alloc_rx+ef/130>
Adhoc e088dffb <[forcedeth]nv_nic_irq+5b/140>
Adhoc c010862d <handle_IRQ_event+3d/70>
Adhoc c01087db <do_IRQ+6b/b0>
Adhoc c01052e0 <default_idle+0/30>
Adhoc c010aa18 <call_do_IRQ+5/d>
Adhoc c01052e0 <default_idle+0/30>
Adhoc c0105306 <default_idle+26/30>
Adhoc c0105382 <cpu_idle+42/60>
Adhoc c0105000 <_stext+0/0>


--------------040300050501090807080701--
