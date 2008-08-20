Return-Path: <linux-kernel-owner+w=401wt.eu-S1753840AbYHTCJ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840AbYHTCJ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 22:09:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751793AbYHTCJu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 22:09:50 -0400
Received: from web32406.mail.mud.yahoo.com ([68.142.207.199]:24481 "HELO
	web32406.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751612AbYHTCJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 22:09:49 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 Aug 2008 22:09:49 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Received:X-Mailer:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type:Message-ID;
  b=xuSwHxaUnxDE2nE1QCPcP/s27/wIhpzJcOLZbxOOJlrZslKEXJOOyzkiO7JOqjivBd+bwgBRQGuwc8DwQuybvj0hUvaMcWKJsP5JcRzhC4ULXybhi/dVU5v55zmZwanw1173I/DJ4ph7Xa43XWNZ3byAJ1Ys61OT5Qy09LdLfgE=;
X-Mailer: YahooMailWebService/0.7.218
Date: Tue, 19 Aug 2008 19:03:08 -0700 (PDT)
From: Anil kumar <anils_r@yahoo.com>
Reply-To: anils_r@yahoo.com
Subject: kill_fasync question
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <377782.37550.qm@web32406.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I know we can use kill_fasync( ) to send signal the user process that data has arrived and maybe by using like ioctl method the user process can get the event data(buffer).

Question:
Is there any way wherein we can send event data(buffer) back to the user process.
kill_fasync( ) takes three parameters async_queue, SIGIO, band.
What I am looking is not only that the driver to signal the user process that data has arrived, but also can send the data back.
-or- 
kill_fasync is used only to notify the user process.

Thanks for your help in advance.

With regards,
  Anil


      
