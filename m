Return-Path: <linux-kernel-owner+w=401wt.eu-S1760151AbYG2Wk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760151AbYG2Wk0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 18:40:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755992AbYG2WkQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 18:40:16 -0400
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:26239 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755483AbYG2WkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 18:40:15 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:Received:Date:From:To:Subject:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=mtBgO3bulqleNeMNzmDKdShMXVJS/nO5R4gB7cpfpuuwfgOBo/P6uPtamuCOuqpMXL+569RI++9H1XjU8sNTvj4yQR0CHOIKdqiZN3PlJ1KQUXmn02O5+kP1cAYLofGlXbh54rU7Ibx39QNJbbVXab0X8Kw8XEx2wEa5AYrmQoQ=  ;
X-YMail-OSG: 3FJmbMkVM1mxUm9OEikJNWr0eLuGXQd2v7KFPn2Dz2UimPvv1_4DPpF2taSOWbn.ThIhh5rdD.gK8RBtO4NinV4r_916INDvP8Mdrkpm4YlIH1zFJLvY.k29CSXQNwFNwxI-
X-Yahoo-Newman-Property: ymail-3
Date: Tue, 29 Jul 2008 15:43:01 -0700
From: David Brownell <david-b@pacbell.net>
To: akpm@linux-foundation.org
Subject: Re: [RESEND PATCH 2.6.26-git 1/2] MTD DataFlash: bugfix, binary page 
 sizes now handled (v3)
Cc: michael.hennerich@analog.com, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, cooloney@kernel.org
References: <1212467165-26379-1-git-send-email-cooloney@kernel.org>
 <200806282321.34275.david-b@pacbell.net>
 <200807251549.12565.david-b@pacbell.net>
 <20080729150052.80e558db.akpm@linux-foundation.org>
In-Reply-To: <20080729150052.80e558db.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080729224301.AD7A3361127@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > This fixes a bug in handling certain newer DataFlash chips (at45db321d
> > and at45db642d have current Linux users) when they were configured to
> > use binary page sizes (possibly at the factory).
> > 
> > ...
>
> I'm not sure what kernel this is against, but it gets a reject storm
> against 2.6.27-rc1.  As does [2/2].

You seem to have picked up the right version ... the problem
was that V2 got merged into RC1, not V3.  So the updated patch
corrected that problem.   The update of the second patch was
unchanged other than the Kconfig tweak (HAVE_MTD_OTP flag)
someone requested.

- Dave
