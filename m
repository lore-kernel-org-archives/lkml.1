Return-Path: <linux-kernel-owner+w=401wt.eu-S1751259AbZKNS1p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751259AbZKNS1p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Nov 2009 13:27:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751156AbZKNS1p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Nov 2009 13:27:45 -0500
Received: from casper.infradead.org ([85.118.1.10]:46495 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143AbZKNS1o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Nov 2009 13:27:44 -0500
Date: Sat, 14 Nov 2009 10:29:19 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: venu <vjosyula@gmail.com>, Roland Dreier <rdreier@cisco.com>,
       Philip Downer <phil@csldevices.co.uk>, linux-kernel@vger.kernel.org
Subject: Re: firmware loading interface
Message-ID: <20091114102919.54606831@infradead.org>
In-Reply-To: <51f3faa70911141019y1248fb27k5f7edb3729f72375@mail.gmail.com>
References: <4AFD971C.3090204@csldevices.co.uk>
	<4AFD9BAF.1010200@csldevices.co.uk>
	<aday6mac5ai.fsf@roland-alpha.cisco.com>
	<4AFED614.1050109@gmail.com>
	<53ea87da0911140855u7993989aod746bcaf18ee4c31@mail.gmail.com>
	<51f3faa70911141019y1248fb27k5f7edb3729f72375@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 14 Nov 2009 12:19:13 -0600
Robert Hancock <hancockrwd@gmail.com> wrote:

> On Sat, Nov 14, 2009 at 10:55 AM, venu <vjosyula@gmail.com> wrote:
> >  who triggers this upgrade from userspace ? I understand it is a
> > naivee / beginers questions but i hope somebody explains me how ?
> 
> The request_firmware interface probably isn't suitable for that..
> using an ioctl or read/write-based interface, possibly on a separate
> device node, would likely be the way to go..
> 

it's not unusual to have a sysfs attribute that, when written to, will
just do a request_firmware().
It's not pretty, but it's cleaner than the alternatives....


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
