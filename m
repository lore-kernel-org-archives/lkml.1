Return-Path: <linux-kernel-owner+w=401wt.eu-S1758848AbYG2PPq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758848AbYG2PPq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 11:15:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751724AbYG2PPg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 11:15:36 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:35814 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310AbYG2PPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 11:15:35 -0400
Subject: Re: [patch 02/15] kmsg: Kernel message catalog script.
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Jochen =?ISO-8859-1?Q?Vo=DF?= <jochen.voss@googlemail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org,
       linux-s390@vger.kernel.org, Michael Holzheu <holzheu@de.ibm.com>
In-Reply-To: <ef1cd66f0807290801q647d7efbn9f9058531bc6f32c@mail.gmail.com>
References: <20080728175355.734299984@de.ibm.com>
	 <20080728175511.260174666@de.ibm.com>
	 <20080728192828.GA11431@uranus.ravnborg.org>
	 <1217320950.10259.15.camel@localhost>
	 <20080729084536.GA29659@uranus.ravnborg.org>
	 <1217329750.10259.38.camel@localhost>
	 <ef1cd66f0807290801q647d7efbn9f9058531bc6f32c@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Organization: IBM Corporation
Date: Tue, 29 Jul 2008 17:15:29 +0200
Message-Id: <1217344529.10259.51.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-07-29 at 16:01 +0100, Jochen Voß wrote:
> Hi Martin,
> 
> I think the changelog needs fixing, too:
> 
> 2008/7/29 Martin Schwidefsky <schwidefsky@de.ibm.com>:
> > The kmsg check is invoked with "make K=1" and reads the source files for
> > all objects that are built by the current configuration and searches for
> > matching kmsg descriptions for the kmsg messages in the source which
> > have a messages id > 0. If a message description can not be found the
> > script prints a blueprint and causes a make error.
> >
> > The kmsg man page creation is invoked with "make K=2" and reads the source
> > files for all built objects, looks up the message description and writes
> > a man page to $(objtree)/man.
> This should be "D=1" and "D=2" now, shouldn't it?

Yes, indeed. Thanks.

-- 
blue skies,
  Martin.

"Reality continues to ruin my life." - Calvin.


