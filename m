Return-Path: <linux-kernel-owner+w=401wt.eu-S1756979AbYFDNTO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756979AbYFDNTO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 09:19:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752630AbYFDNS7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 09:18:59 -0400
Received: from smtpout01s1.x-echo.com ([193.252.149.37]:53037 "EHLO
	smtpout01s1.x-echo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002AbYFDNS7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 09:18:59 -0400
From: Lkm <lkm@lea-linux.com>
To: "Bart Van Assche" <bart.vanassche@gmail.com>
Subject: Re: PROBLEM: Hardware clock instable
Date: Wed, 4 Jun 2008 15:17:43 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <200806041402.39515.lkm@lea-linux.com> <e2e108260806040549p11117410x192d1020adb885c7@mail.gmail.com>
In-Reply-To: <e2e108260806040549p11117410x192d1020adb885c7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200806041517.43347.lkm@lea-linux.com>
X-AV-Checked: ClamAV using ClamSMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le Wednesday 04 June 2008 14:49:58 Bart Van Assche, vous avez écrit :
> On Wed, Jun 4, 2008 at 2:02 PM, Lkm <lkm@lea-linux.com> wrote:
> > i work in a web hosting compagny. We have a strange problem on many
> > servers. The hardware clock of several server is totaly instable. This
> > happen on many server, not all.
>
> Which messages are logged by the NTP daemon during the first 24 hours
> after it has been started ? On Debian systems you can install NTP by
> running apt-get install ntp.
>
> Bart.

Ntpd logs:

28 May 10:32:17 ntpd[31086]: synchronized to 192.168.0.150, stratum 3
28 May 10:51:34 ntpd[31086]: synchronized to 192.168.0.151, stratum 3
29 May 00:20:57 ntpd[31086]: synchronized to 192.168.0.150, stratum 3
29 May 01:46:28 ntpd[31086]: synchronized to 192.168.0.151, stratum 3
29 May 02:27:10 ntpd[31086]: synchronized to 192.168.0.150, stratum 3
29 May 02:33:34 ntpd[31086]: synchronized to 192.168.0.151, stratum 3
29 May 02:39:02 ntpd[31086]: synchronized to 192.168.0.150, stratum 3
29 May 04:02:28 ntpd[31086]: synchronized to 192.168.0.151, stratum 3
29 May 04:45:12 ntpd[31086]: synchronized to 192.168.0.150, stratum 3
29 May 09:01:20 ntpd[31086]: synchronized to 192.168.0.151, stratum 3
31 May 16:16:55 ntpd[31086]: synchronized to 192.168.0.150, stratum 3
31 May 17:33:50 ntpd[31086]: synchronized to 192.168.0.151, stratum 3
31 May 17:59:26 ntpd[31086]: synchronized to 192.168.0.150, stratum 3
31 May 18:33:32 ntpd[31086]: synchronized to 192.168.0.151, stratum 3
31 May 18:47:22 ntpd[31086]: synchronized to 192.168.0.150, stratum 3
31 May 18:52:04 ntpd[31086]: synchronized to 192.168.0.151, stratum 3
31 May 18:55:53 ntpd[31086]: synchronized to 192.168.0.150, stratum 3
31 May 19:49:25 ntpd[31086]: synchronized to 192.168.0.151, stratum 3
31 May 20:28:30 ntpd[31086]: synchronized to 192.168.0.150, stratum 3
31 May 21:45:19 ntpd[31086]: synchronized to 192.168.0.151, stratum 3
 2 Jun 05:28:59 ntpd[31086]: synchronized to 192.168.0.150, stratum 3
 2 Jun 10:46:26 ntpd[31086]: ntpd exiting on signal 15
 2 Jun 10:53:32 ntpd[2299]: synchronized to 192.168.0.150, stratum 3
 2 Jun 10:53:32 ntpd[2299]: kernel time sync enabled 0001
 2 Jun 11:02:11 ntpd[2299]: synchronized to 192.168.0.151, stratum 3
 2 Jun 11:06:36 ntpd[2299]: synchronized to 192.168.0.150, stratum 3
 2 Jun 11:19:26 ntpd[2299]: synchronized to 192.168.0.151, stratum 3
 2 Jun 11:55:56 ntpd[2299]: synchronized to 192.168.0.150, stratum 3
 2 Jun 12:34:24 ntpd[2299]: synchronized to 192.168.0.151, stratum 3
 2 Jun 13:00:08 ntpd[2299]: synchronized to 192.168.0.150, stratum 3
 2 Jun 13:33:44 ntpd[2299]: ntpd exiting on signal 15
 2 Jun 13:42:20 ntpd[2299]: synchronized to 192.168.0.150, stratum 3
 2 Jun 13:42:20 ntpd[2299]: time reset -109.498922 s
 2 Jun 13:42:20 ntpd[2299]: kernel time sync enabled 0001
 2 Jun 13:45:34 ntpd[2299]: synchronized to 192.168.0.151, stratum 3
 2 Jun 14:21:59 ntpd[2299]: synchronized to 192.168.0.150, stratum 3
 2 Jun 14:30:41 ntpd[2299]: synchronized to 192.168.0.151, stratum 3
 2 Jun 15:33:28 ntpd[2299]: ntpd exiting on signal 15
 2 Jun 15:39:55 ntpd[2300]: ntpd exiting on signal 15
 2 Jun 15:46:39 ntpd[2354]: synchronized to 192.168.0.150, stratum 3
 2 Jun 15:46:39 ntpd[2354]: kernel time sync enabled 0001
 2 Jun 15:54:11 ntpd[2354]: synchronized to 192.168.0.151, stratum 3
 2 Jun 15:59:36 ntpd[2354]: synchronized to 192.168.0.150, stratum 3
 2 Jun 16:27:25 ntpd[2354]: synchronized to 192.168.0.151, stratum 3
 2 Jun 16:36:06 ntpd[2354]: synchronized to 192.168.0.150, stratum 3
 2 Jun 17:01:40 ntpd[2354]: synchronized to 192.168.0.151, stratum 3
 2 Jun 17:50:52 ntpd[2354]: synchronized to 192.168.0.150, stratum 3
 3 Jun 01:31:52 ntpd[2354]: synchronized to 192.168.0.151, stratum 3


Other (useful?) logs:

Jun  4 14:29:53 rd10 kernel: set_rtc_mmss: can't update from 77 to 29
Jun  4 14:29:54 rd10 kernel: set_rtc_mmss: can't update from 77 to 29
Jun  4 14:29:55 rd10 kernel: set_rtc_mmss: can't update from 77 to 29
Jun  4 14:29:56 rd10 kernel: set_rtc_mmss: can't update from 77 to 29
Jun  4 14:29:57 rd10 kernel: set_rtc_mmss: can't update from 77 to 29
Jun  4 14:29:58 rd10 kernel: set_rtc_mmss: can't update from 77 to 29
Jun  4 14:29:59 rd10 kernel: set_rtc_mmss: can't update from 77 to 29
Jun  4 14:30:00 rd10 kernel: set_rtc_mmss: can't update from 78 to 30
Jun  4 14:30:01 rd10 kernel: set_rtc_mmss: can't update from 78 to 30
Jun  4 14:30:02 rd10 kernel: set_rtc_mmss: can't update from 78 to 30
Jun  4 14:30:03 rd10 kernel: set_rtc_mmss: can't update from 78 to 30
Jun  4 14:30:04 rd10 kernel: set_rtc_mmss: can't update from 78 to 30
Jun  4 14:30:05 rd10 kernel: set_rtc_mmss: can't update from 78 to 30
Jun  4 14:30:06 rd10 kernel: set_rtc_mmss: can't update from 78 to 30
Jun  4 14:30:07 rd10 kernel: set_rtc_mmss: can't update from 78 to 30
Jun  4 14:30:08 rd10 kernel: set_rtc_mmss: can't update from 78 to 30
Jun  4 14:30:09 rd10 kernel: set_rtc_mmss: can't update from 78 to 30
Jun  4 14:30:10 rd10 kernel: set_rtc_mmss: can't update from 78 to 30
Jun  4 14:30:11 rd10 kernel: set_rtc_mmss: can't update from 78 to 30
Jun  4 14:30:12 rd10 kernel: set_rtc_mmss: can't update from 78 to 30
Jun  4 14:30:13 rd10 kernel: set_rtc_mmss: can't update from 78 to 30
Jun  4 14:30:14 rd10 kernel: set_rtc_mmss: can't update from 78 to 30
Jun  4 14:30:15 rd10 kernel: set_rtc_mmss: can't update from 78 to 30
Jun  4 14:30:16 rd10 kernel: set_rtc_mmss: can't update from 78 to 30
Jun  4 14:30:17 rd10 kernel: set_rtc_mmss: can't update from 78 to 30
Jun  4 14:30:18 rd10 kernel: set_rtc_mmss: can't update from 78 to 30
Jun  4 14:30:19 rd10 kernel: set_rtc_mmss: can't update from 78 to 30
Jun  4 14:30:20 rd10 kernel: set_rtc_mmss: can't update from 78 to 30
Jun  4 14:30:21 rd10 kernel: set_rtc_mmss: can't update from 78 to 30
Jun  4 14:30:22 rd10 kernel: set_rtc_mmss: can't update from 78 to 30
Jun  4 14:30:23 rd10 kernel: set_rtc_mmss: can't update from 78 to 30
Jun  4 14:30:24 rd10 kernel: set_rtc_mmss: can't update from 78 to 30
Jun  4 14:30:25 rd10 kernel: set_rtc_mmss: can't update from 78 to 30
Jun  4 14:30:26 rd10 kernel: set_rtc_mmss: can't update from 78 to 30
Jun  4 14:30:27 rd10 kernel: set_rtc_mmss: can't update from 78 to 30
Jun  4 14:30:28 rd10 kernel: set_rtc_mmss: can't update from 78 to 30
Jun  4 14:30:29 rd10 kernel: set_rtc_mmss: can't update from 78 to 30
Jun  4 14:30:30 rd10 kernel: set_rtc_mmss: can't update from 78 to 30
Jun  4 14:30:31 rd10 kernel: set_rtc_mmss: can't update from 78 to 30
Jun  4 14:30:32 rd10 kernel: set_rtc_mmss: can't update from 78 to 30
Jun  4 14:30:33 rd10 kernel: set_rtc_mmss: can't update from 78 to 30
Jun  4 14:30:34 rd10 kernel: set_rtc_mmss: can't update from 78 to 30
Jun  4 14:30:35 rd10 kernel: set_rtc_mmss: can't update from 78 to 30
Jun  4 14:30:36 rd10 kernel: set_rtc_mmss: can't update from 78 to 30
Jun  4 14:30:37 rd10 kernel: set_rtc_mmss: can't update from 78 to 30
Jun  4 14:30:38 rd10 kernel: set_rtc_mmss: can't update from 78 to 30
Jun  4 14:30:39 rd10 kernel: set_rtc_mmss: can't update from 78 to 30
Jun  4 14:30:40 rd10 kernel: set_rtc_mmss: can't update from 78 to 30
Jun  4 14:30:41 rd10 kernel: set_rtc_mmss: can't update from 78 to 30
Jun  4 14:30:42 rd10 kernel: set_rtc_mmss: can't update from 78 to 30
Jun  4 14:30:43 rd10 kernel: set_rtc_mmss: can't update from 78 to 30
Jun  4 14:30:44 rd10 kernel: set_rtc_mmss: can't update from 78 to 30
Jun  4 14:30:45 rd10 kernel: set_rtc_mmss: can't update from 78 to 30
Jun  4 14:30:46 rd10 kernel: set_rtc_mmss: can't update from 78 to 30
Jun  4 14:30:47 rd10 kernel: set_rtc_mmss: can't update from 78 to 30
:                                                                                             
