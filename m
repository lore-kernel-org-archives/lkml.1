Return-Path: <linux-kernel-owner+w=401wt.eu-S1759498AbYBRLI1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759498AbYBRLI1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 06:08:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756388AbYBRLIU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 06:08:20 -0500
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:21916 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756364AbYBRLIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 06:08:19 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=PHNkqSFxISJGrsDxGku6nY1g1eI4sNgCxxk8ooCiYpw6IFnCMON+lSEnbHSMT1MPN5eqgnJ0bktAK5g2ZoYoqxdK8jkORRk0dZv5fAPV7mbgF6aA6yj7mgeJnUsEU/ryoyNdH/r7FsOhA20NzY0RvmElJEK5nMcn3StFHxlFpQ0=  ;
X-YMail-OSG: BO0oaqsVM1lqEw8l0gM9.fyUOLWAW9VWWxI5R4Jg5eYwX3zcTO8dR5gPVRcYN1_3NB5dyp0TjA--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: WARN_ON(): proc_dir_entry 'rtc' already registered
Date: Mon, 18 Feb 2008 03:08:16 -0800
User-Agent: KMail/1.9.6
Cc: kernel list <linux-kernel@vger.kernel.org>
References: <20080212132626.GA1534@elf.ucw.cz> <200802121029.08007.david-b@pacbell.net> <20080218105441.GE7198@elf.ucw.cz>
In-Reply-To: <20080218105441.GE7198@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200802180308.17115.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 18 February 2008, Pavel Machek wrote:
> > How to fix ... how about:  instead of just warning folk
> > off such legacy RTC drivers [1] we just wrap them with
> > an "if RTC_LIB != n" so this mistake won't be possible.
> 
> Yes, disabling bad configs in Kconfig seems like way to go.

Problem is ... that also disables valid configs that
get assembled by picking the right module(s) for the
target system.

