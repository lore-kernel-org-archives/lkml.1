Return-Path: <linux-kernel-owner+w=401wt.eu-S965042AbXBYRvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965042AbXBYRvU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 12:51:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965046AbXBYRvU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 12:51:20 -0500
Received: from smtp003.mail.ukl.yahoo.com ([217.12.11.34]:46187 "HELO
	smtp003.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S965042AbXBYRvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 12:51:19 -0500
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Sun, 25 Feb 2007 12:51:19 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.it;
  h=Received:X-YMail-OSG:Subject:From:To:Cc:Content-Type:Organization:Date:Message-Id:Mime-Version:X-Mailer:Content-Transfer-Encoding;
  b=EEon6jdhfAXJGGbqLn1irUKH6jUyVlwLf7MptSOfYBwuKIJTsvWtVxFODJVkCBjeM1Tv7EwX35rICanabbf5T2bNf8wsCiNHh4LxUMSiU2EjRxajn0j07z6+Oa2VvJVnXkngpClcchLp9AYKiGTZURlUssBsdetfltG+q/aP/jY=  ;
X-YMail-OSG: 1x5sR2AVM1lXhb5ZOJfZCkG7YplrApZMs3Lpn0eHpc6uPScYOJj.b6XDpnSaTVzVcePTltI1JKI9OYSfEpVTyW.Mmn1Ebx3ZwznWaZVZ1J2WZnPVliel_yQlNs.imgTcMprKw8dczsNB
Subject: SMP performance degradation with sysbench
From: Lorenzo Allegrucci <l_allegrucci@yahoo.it>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Suparna Bhattacharya <suparna@in.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>
Content-Type: text/plain
Organization: -ENOENT
Date: Sun, 25 Feb 2007 18:44:35 +0100
Message-Id: <1172425476.5489.11.camel@odyssey.lan>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi lkml,

according to the test below (sysbench) Linux seems to have scalability
problems beyond 8 client threads:
http://jeffr-tech.livejournal.com/6268.html#cutid1
http://jeffr-tech.livejournal.com/5705.html
Hardware is an 8-core amd64 system and jeffr seems willing to try more
Linux versions on that machine.
Anyway, is there anyone who can reproduce this?


Chiacchiera con i tuoi amici in tempo reale! 
 http://it.yahoo.com/mail_it/foot/*http://it.messenger.yahoo.com 
