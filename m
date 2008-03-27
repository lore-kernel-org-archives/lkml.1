Return-Path: <linux-kernel-owner+w=401wt.eu-S1761507AbYC0THl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761507AbYC0THl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 15:07:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756708AbYC0THR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 15:07:17 -0400
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:48612 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755570AbYC0THP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 15:07:15 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=o2fVphiHljocg+/qvxd/PcUsB3pXair5egsb+BGVvDXkhCcWqDDEiQCtgZE6PYLtw8afHCwhiPvIk3MvCT6fOrKxLeUN3RO5yH3VSYY+AnXBgt0apV9iXSeOnhmZkv/jZKFpqXxoryq2B9Vrcu7nPOrXov6sDYfzgZ330FCPpBc=  ;
X-YMail-OSG: hfxxovwVM1lYivIiOiiiv.M1hCnJ2mz5KUVxEa06WleqmQ8_O0lNCjnGxu_gk1H6KrQW1N6ZCg--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: "Mike Nuss" <mikenuss@gmail.com>,
       "Richard Kennedy" <richard@rsk.demon.co.uk>
Subject: Re: ohci : strange looking use of round_jiffies_relative. possible bug ?
Date: Thu, 27 Mar 2008 11:55:24 -0700
User-Agent: KMail/1.9.6
Cc: "Alan Stern" <stern@rowland.harvard.edu>,
       linux-usb <linux-usb@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.0803261136590.6324-100000@iolanthe.rowland.org> <1206546405.2931.20.camel@castor.localdomain> <a340dd0e0803261106v67bbecdaie8a3f52b47e2c84a@mail.gmail.com>
In-Reply-To: <a340dd0e0803261106v67bbecdaie8a3f52b47e2c84a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803271155.25302.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 26 March 2008, Mike Nuss wrote:
> On Wed, Mar 26, 2008 at 11:46 AM, Richard Kennedy
> <richard@rsk.demon.co.uk> wrote:
> 
> >  > I'd say it's a bug.  Or rather a pair of bugs, since that mod_timer()
> >  > call appears in two places.
> 
> Yup.

Although ... one specific to the Compaq ZF Micro chipset,
so it's a bug with rather limited impact.  Do Not Panic.


