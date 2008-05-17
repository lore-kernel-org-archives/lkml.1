Return-Path: <linux-kernel-owner+w=401wt.eu-S1756641AbYEQOhy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756641AbYEQOhy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 10:37:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754861AbYEQOhp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 10:37:45 -0400
Received: from smtp107.sbc.mail.mud.yahoo.com ([68.142.198.206]:22574 "HELO
	smtp107.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755962AbYEQOhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 10:37:43 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=I0y3bcsEPOnhHNJVYENcMeyCZtlxECmcFziT2DEbPr5koi7inbM42XxNw3VFcjvos+u30XPXnkYp1yO2bd02TsN3Q+EnCGDUj58n68AvXPzoqihX4IDdV/WEPdNIh4yNHPJyFoIztujSvBWA65Bozg6X2Ex/xgotLn4JKY6KYz8=  ;
X-YMail-OSG: LwRaKAwVM1ns.efuE8X22DcDyEFLR.c16B2PQMm0MDnC7wg.pz4su718FpvhNxFK9QZNYz3dGQ8MN3T.Z9vUj8b6s7ukvq2PyqQ3brpEocaUISqXhsiEZpsLek7IVQzmu5w-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Bryan Wu <cooloney@kernel.org>
Subject: Re: [PATCH 0/2] MUSB: 2 patches to fix some bug found on Blackfin
Date: Sat, 17 May 2008 07:37:37 -0700
User-Agent: KMail/1.9.6
Cc: me@felipebalbi.com, tony@atomide.com, linux-omap@vger.kernel.org,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1211022081-27298-1-git-send-email-cooloney@kernel.org>
In-Reply-To: <1211022081-27298-1-git-send-email-cooloney@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805170737.37806.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 17 May 2008, Bryan Wu wrote:
> 
> We discussed these 4 bugs before. Now we fixed them.
> Please review following 2 patches.

They looked plausible to me ... though the urb->status
one is a bit of a band-aid, and when that field finally
vanishes a better fix will be needed.

- Dave
