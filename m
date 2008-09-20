Return-Path: <linux-kernel-owner+w=401wt.eu-S1755900AbYITA4b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755900AbYITA4b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 20:56:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752815AbYITA4W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 20:56:22 -0400
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:45910 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751153AbYITA4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 20:56:21 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=r/dwSDJMDZXKAetYiL9b5yytsGqe1zrwZmu0a/F5AqQF9t+eYVO38sLF6YAL3CxLsJzkmlFaB2EgYtkLO3Ax7hhwgMosTHnk9puGIpCdUVstZoDeSiScdg6nkDAS8N4PiovubVvCE3CO9pXL3DDz0uQ57ds0WPxJs1SI0SgzAMo=  ;
X-YMail-OSG: kp3_aZYVM1k9YRaSBvq0rmC_VP4XwfIl2U639gFvk2prmvDZPgYJBWrI8DxxRiMvp1biX9vge5.zBkXtTw.0arP5Am498D63MDkAtwfa1lapp6q0rexjxMEu.T7dpW.FJi5Z4fxfZpAeIeur9M_iKdNBUjtngw--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: "Justin Mattock" <justinmattock@gmail.com>
Subject: Re: [19.666764] Disabling IRQ #23
Date: Fri, 19 Sep 2008 17:56:18 -0700
User-Agent: KMail/1.9.9
Cc: "Alan Stern" <stern@rowland.harvard.edu>,
       "Bjorn Helgaas" <bjorn.helgaas@hp.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Yinghai Lu" <yhlu.kernel@gmail.com>, "Chris Snook" <csnook@redhat.com>,
       Linux-usb <linux-usb@vger.kernel.org>
References: <dd18b0c30809190941g8b44175haf3e3a7c354fe01c@mail.gmail.com> <dd18b0c30809191118u20a13ff3m801a23397eb6beed@mail.gmail.com> <dd18b0c30809191420xe1ff525rbf59bb5d9f9910b2@mail.gmail.com>
In-Reply-To: <dd18b0c30809191420xe1ff525rbf59bb5d9f9910b2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809191756.18661.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In

  http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/gregkh-02-usb.current/

the patch

  usb-fix-ehci-periodic-transfers.patch

seems like it should resolve the root cause of this, and

 usb-ehci-fix-some-ehci-hangs-and-crashes.patch

would cover symptoms which probably caused the "Disabling..." message.
Both patches were in that LKML thread you referenced.
