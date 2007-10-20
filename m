Return-Path: <linux-kernel-owner+w=401wt.eu-S1757772AbXJTOR6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757772AbXJTOR6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 10:17:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752404AbXJTORu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 10:17:50 -0400
Received: from smtp105.mail.mud.yahoo.com ([209.191.85.215]:29439 "HELO
	smtp105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752151AbXJTORt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 10:17:49 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:MIME-Version:To:Subject:Content-Type:Content-Transfer-Encoding;
  b=Y1mhKCqjiN83a/aS+FsXtzG1Agy3Kit9KB5vfBYQj3Ip9pYuFhzMelwBZkP5YQ/8ZOoA+R1ianliw0OvKVYrEsHvonljaQJX6htxxX+o/FCttLns9HRT4hKhgMyj55QDCnQtoV64qCUHJEVHzoQLxdPOCJoBBsytV1rvZf8V2ds=  ;
X-YMail-OSG: RD8WXA8VM1kw2WKzymqrfQbHiqFFeM_iTtYZhC5upQ9pQRWbt7VK03ghVMH4qasIdAJFQD2X1w--
Message-ID: <471A0DF4.50700@yahoo.com.au>
Date: Sat, 20 Oct 2007 22:17:24 +0800
From: Ben <benjg87@yahoo.com.au>
User-Agent: Thunderbird 2.0.0.6 (X11/20071008)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Problem with reiserfs in 2.6.23-mm1
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Whenever I log into xfce with gdm my computer will freeze when i use 
reiserfs as my /home on 2.6.23-mm1. Logging into the VT works perfectly 
fine. Previously my system would crash when logging into the VT but the
make-reiserfs-stop-using-struct-file-for-internal.patch patch fixed the 
issue(and possibly introduced the issue I currently have). My system 
works perfectly fine using 2.6.23-rc6-mm1 and prior. /home is mounted 
with the following options: /dev/sda3 on /home type reiserfs 
(rw,nosuid,nodev,noatime,acl)
