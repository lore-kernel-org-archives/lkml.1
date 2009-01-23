Return-Path: <linux-kernel-owner+w=401wt.eu-S1758353AbZAWWHf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758353AbZAWWHf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 17:07:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756219AbZAWWHJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 17:07:09 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50416 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755646AbZAWWHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 17:07:06 -0500
Message-ID: <497A3E23.7040606@zytor.com>
Date: Fri, 23 Jan 2009 14:01:07 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@medozas.de>
CC: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       "H. Peter Anvin" <hpa@kernel.org>, Sam Ravnborg <sam@ravnborg.org>,
       David Woodhouse <dwmw2@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       x86 maintainers <x86@kernel.org>, urs.thuermann@volkswagen.de,
       oliver.hartkopp@volkswagen.de, linux-media@vger.kernel.org,
       netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
       bfields@fieldses.org, neilb@suse.de, linux-nfs@vger.kernel.org,
       linux-raid@vger.kernel.org, dbrownell@users.sourceforge.net,
       netdev@vger.kernel.org, greg@kroah.com, linux-usb@vger.kernel.org,
       linux-mtd@lists.infradead.org, tiwai@suse.de, mchehab@infradead.org,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL -tip] fix 33 make headers_check warnings
References: <1232223441.3966.22.camel@localhost.localdomain>  <1232228261.27094.0.camel@macbook.infradead.org>  <20090117221932.GA4956@uranus.ravnborg.org>  <49725B1E.604@kernel.org>  <1232498319.3123.34.camel@localhost.localdomain>  <1232726359.3504.18.camel@localhost.localdomain> <1232726658.3504.22.camel@localhost.localdomain> <alpine.LSU.2.00.0901231710350.15413@fbirervta.pbzchgretzou.qr> <497A3793.5090502@zytor.com> <alpine.LSU.2.00.0901232252510.25716@fbirervta.pbzchgretzou.qr>
In-Reply-To: <alpine.LSU.2.00.0901232252510.25716@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> 
> Hm, maybe g++ defaults to std? Because this works without me using
> "using std;"
> 
> #include <cstdint>
> int main(void)
> {
> 	uint32_t x;
> }
> 

Sorry, this was a bit of a surprise... basically the g++ <cstdint> 
functionally does #include <stdint.h> then exports the symbols into the 
std namespace, so it puts them into both...

	-hpa


