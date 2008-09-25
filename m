Return-Path: <linux-kernel-owner+w=401wt.eu-S1755843AbYIYUts@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755843AbYIYUts (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 16:49:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752705AbYIYUtk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 16:49:40 -0400
Received: from web38203.mail.mud.yahoo.com ([209.191.124.146]:34253 "HELO
	web38203.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752503AbYIYUtk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 16:49:40 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=PCKKN7JZ22cOZlk0kwj+Y7sKPumtpil+rEVTo4ksEP10NOkxRP3/N/c9g524hRvYMbs3dE/zC2ZlljyofOqo+JFXOLsnInMYq9sPfTvrjab8Q74k38G6ei5CHQ9L/X1Pz82qFUGASxXZGhZFDlOEXjkx3DfiA0+EVRZQoNerQTo=;
X-YMail-OSG: Sy80OpEVM1ljTqHACkJmAriPgx1HFw0U.Yu96pSqaKMXPe8.BWnqqIojFi2IoC2PpRBq3AeKfAHsIPDsuVmnnMgMqw61cK5UhnO8LFD9PaxNZXMQCre0fFAnIQuY2knHa84jb6psipmlfoY4dAaZSqk0_QW1
X-Mailer: YahooMailRC/1096.28 YahooMailWebService/0.7.218.2
Date: Thu, 25 Sep 2008 13:49:39 -0700 (PDT)
From: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: Re: Turning off camera also kills card reader on EeePC 900
To: Pascal Terjan <pterjan@gmail.com>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Corentin Chary <corentincj@iksaif.net>,
       acpi4asus-user@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Message-ID: <579556.5870.qm@web38203.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, Sep 15, 2008 at 3:37 PM, Alan Jenkins
> wrote:
> > Sitsofe Wheeler wrote:
> > The "HC died" message is interesting.  Sounds like the controller for
> > these two USB devices stops working.  Maybe try unloading and reloading
> > the ehci module?  I don't think I can help any more though.
> 
> The issue also exist on 701 on 2.6.27-rc7 so the regression is in the
> kernel not in the hardware
> 
[snip]
> 
> So it looks like an ehci_hcd issue when the camera is disabled


And of course, having tried Ingo Molnar's linux-tip (whereas before I was using 2.6.27) I have now found a modern kernel that doesn't exhibit the problem...


      
