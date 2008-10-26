Return-Path: <linux-kernel-owner+w=401wt.eu-S1756110AbYJZUTy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756110AbYJZUTy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 16:19:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753167AbYJZUTq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 16:19:46 -0400
Received: from web56305.mail.re3.yahoo.com ([216.252.110.229]:36358 "HELO
	web56305.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754150AbYJZUTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 16:19:45 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type:Message-ID;
  b=eJxA0EpO+YaaPO95lOtKh7RnRVv3p6sUL98p7F6Mm+kuHKwCKlaNtLmi5KvrRpOUzRkg9NxW/ZzUiGRtMPkIfzgGWFdPByvILgh/VidcCVqJ2KZHkLvxKp/CPgP2+plJh1K1Z87IMVaF78RsjyfQhYG0RzCf2sFur6rl5EVNDrQ=;
X-YMail-OSG: JBi5HnkVM1lVFjOUf8DbsZLNPbWZ2jtQ2zYczO3E6luIjlsKqepJrvBrJyZHpyzKq0Iz3wQmOxSb4x_8RiKheDni5.9hPEJ8zu9dzFa0JYQDV41xtGRNkahUr8_MYNtPHZM0xmzj5h7FMLjVfF3GUObt4vpdQCx1snQM0l8-
X-Mailer: YahooMailWebService/0.7.247.3
Date: Sun, 26 Oct 2008 13:19:44 -0700 (PDT)
From: Paul P <ppak_98@yahoo.com>
Reply-To: ppak_98@yahoo.com
Subject: Fw: Re: unexpected extra pollout events from epoll
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <521981.87335.qm@web56305.mail.re3.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'm not too familiar with the edge triggered mode, but
> you shouldn't be requesting EPOLLOUT notifications if you don't care
> about them (i.e. if you are not trying to write anything).
 
I am trying to write something, but I don't understand this behavior because it will screw up my notifications when I'm trying to see if I should write
more because of the extra notifications.  Even before I started writing anything, I'm getting these epollout events which I was not expecting.

Paul


      
