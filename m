Return-Path: <linux-kernel-owner+w=401wt.eu-S1751202AbYF2FER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751202AbYF2FER (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 01:04:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753223AbYF2FDz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 01:03:55 -0400
Received: from smtp123.sbc.mail.sp1.yahoo.com ([69.147.64.96]:24541 "HELO
	smtp123.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753207AbYF2FDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 01:03:53 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=ZjrnPXoH2/IguPOz1r2+/chJ4LsUeJkCIwlvguNbnWEsAjZ2e6yULWOcyGRld2UXw6Q4289jl2mTWFogKkswUcGoaLdNL3o4bNWESXNLuADtlZluNi87RVJHZpdjVdQMymjlXWuaFHuGQUdbNLznZVW9aT3OoCasac8e1IpsWIg=  ;
X-YMail-OSG: ZXO4EmgVM1nGjbKP3iSzU6ej1ArUTyeIWBiZKs0evThlW584tbmSRkzSscxEqAFwvuMi1kYcQfzTUEG0F5wD1Tx6oruXMj82ZdUmIabrlq9rNig4Ajg9bV9lcYJnCNe5heY-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: "Becker Stefan (Nokia-D/Salo)" <Stefan.Becker@nokia.com>
Subject: Re: BUG in 2.6.26-rc8 interrupt handling
Date: Sat, 28 Jun 2008 12:51:21 -0700
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       ext Alan Stern <stern@rowland.harvard.edu>
References: <Pine.LNX.4.44L0.0806281241200.23326-100000@netrider.rowland.org> <48669252.1000608@nokia.com>
In-Reply-To: <48669252.1000608@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200806281251.21299.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 28 June 2008, Becker Stefan (Nokia-D/Salo) wrote:
>  11:         36    XT-PIC-XT        yenta, ehci_hcd:usb1, uhci_hcd:usb3

Do things improve if you "rmmod yenta" or, better yet, never
load that module?

