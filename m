Return-Path: <linux-kernel-owner+w=401wt.eu-S1753360AbYI3HIr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360AbYI3HIr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 03:08:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752099AbYI3HIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 03:08:39 -0400
Received: from web30108.mail.mud.yahoo.com ([209.191.69.40]:34790 "HELO
	web30108.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752097AbYI3HIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 03:08:38 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Sep 2008 03:08:38 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type:Message-ID;
  b=HOp9g0lygYByOY/Z/Crz/nHyNKQwUcusRgGMo/UfQhWy6I+F4SbJ+fH1zekj6EjHs0eYa2qfR8kk+TI7bfU1XndkGSBlA1AeQ2pGfbwlzpbIbSE9PJsgYPI34PfXxaGxSEZXxaj90+wVDFRZmT8tUXuLZG5oD8+uWuKZufaBWWA=;
X-YMail-OSG: u4j0QsUVM1mcq4w7SrBaPkPqaHgLjQYldnT8UWxFagDRh3TjmpeghJyRodMEFXXy40.F3o1dFAC8AEWL6ngi4wzRL0IiPLX5RRE2R0FrenLJgSFVOYgmjtgUKJ6frBUcEMcmczGydGns59yBOoXtVOUrh6gt
X-Mailer: YahooMailWebService/0.7.218.2
Date: Tue, 30 Sep 2008 00:01:55 -0700 (PDT)
From: Parav Pandit <paravpandit@yahoo.com>
Reply-To: paravpandit@yahoo.com
Subject: Calculating time in order of 0.1usec on x86 system
To: Linux kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <855204.33912.qm@web30108.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I need to calculate time spent by a function in order of less then a microsecond on x86 SMP platform.

Current profiling tools and gettimeofday() are not sufficient.

So I am using get_cycles() to get the CPU cycles.

Now how do I convert it into the time interval?

Do I have to divide it by "cpu_khz" variable? Or some other method?
Is yes, what will be the unit of the result (time interval)? nsec/usec/msec?

e.g. get_cycles()/cpu_khz (unit?)

Or Is there more simpler method exist?

Regards,
Parav Pandit


      
