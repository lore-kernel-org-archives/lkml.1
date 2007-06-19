Return-Path: <linux-kernel-owner+w=401wt.eu-S1759209AbXFSRnr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759209AbXFSRnr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 13:43:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757708AbXFSRni
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 13:43:38 -0400
Received: from utopia.booyaka.com ([72.9.107.138]:37456 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760535AbXFSRnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 13:43:37 -0400
X-Greylist: delayed 402 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 Jun 2007 13:43:36 EDT
Comment: DomainKeys? See http://antispam.yahoo.com/domainkeys
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=default; d=booyaka.com;
  b=K8IkrIEszPGvdPxsx23HVY0getVbDQquVB7Be1t76hf0DATmX6eAWovuVvWkbWjWPuVOsaB4Ol1MGmWxm7wEWKL3csFF7uhK9papS1siP3aI4c+2oUxQBbMOfuNYFzQfOf9Q3diEJfXauMIxw0KC8mt5CkvIMS9yH/YxGCXfMq1X2fQYeFM/yqvegdVXIBZ37c1dCcjegwkOf350RQIrW50cY0A+sFWyg9NEV1l3eXkBn6yB27xllkR+i09Gdvd02N+8vgjSvI0VnDG+DD5RhYQ+Rp+nsODdmCV6jfye2jZEfiKDEySAo1/hT4j6GTmRqM4WirIeI7p6IPoN6hATiA==  ;
Date: Tue, 19 Jun 2007 11:36:53 -0600 (MDT)
From: Paul Walmsley <paul@booyaka.com>
To: Oliver Neukum <oliver@neukum.org>
cc: linux-usb-devel@lists.sourceforge.net, Chuck Ebbert <cebbert@redhat.com>,
       "Renato S. Yamane" <renatoyamane@mandic.com.br>,
       linux-kernel@vger.kernel.org
Subject: Re: [linux-usb-devel] Error -71 on device descriptor read/all
In-Reply-To: <200706191902.08173.oliver@neukum.org>
Message-ID: <Pine.LNX.4.64.0706191134160.12843@utopia.booyaka.com>
References: <4677EBF8.5020104@mandic.com.br> <467801A4.4030004@redhat.com>
 <200706191902.08173.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Jun 2007, Oliver Neukum wrote:

> Am Dienstag, 19. Juni 2007 schrieb Chuck Ebbert:
>
>> Try disabling CONFIG_USB_SUSPEND
>>
>> [usb developers: what are the drawbacks of doing this?]
>
> Increased power consumption.

speaking of CONFIG_USB_SUSPEND, I've encountered at least one device -- a 
Canon EOS 5D camera -- that, after the bus suspends, must be powercycled 
in order to return the camera's interrupt endpoints to a functional state. 
How are these types of problems handled, currently?  Is this something for 
a blacklist?


- Paul
