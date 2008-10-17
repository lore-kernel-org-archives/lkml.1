Return-Path: <linux-kernel-owner+w=401wt.eu-S1757360AbYJQRDH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757360AbYJQRDH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 13:03:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756137AbYJQRCy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 13:02:54 -0400
Received: from hera.kernel.org ([140.211.167.34]:56964 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756135AbYJQRCx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 13:02:53 -0400
Message-ID: <48F8C4FC.8010908@kernel.org>
Date: Fri, 17 Oct 2008 10:01:48 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: n0ano@n0ano.com
CC: Paul Bolle <pebolle@tiscali.nl>, donald.d.dugger@intel.com,
       linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] Enable console on PCI serial devices
References: <1224061999.25929.7.camel@test.thuisdomein> <20081015204850.GC14490@xolotl.n0ano.com> <1224153822.3587.23.camel@test.thuisdomein> <48F76A8B.6050306@kernel.org> <20081016171218.GD14490@xolotl.n0ano.com> <48F785B0.7000008@kernel.org> <20081016182556.GE14490@xolotl.n0ano.com> <86802c440810161130x304128faj6b1a1a6e1b90ed03@mail.gmail.com> <20081017024544.GB9378@xolotl.n0ano.com> <86802c440810162032i25d7af9dk6fb8782b534e16d1@mail.gmail.com> <20081017160527.GI14490@xolotl.n0ano.com>
In-Reply-To: <20081017160527.GI14490@xolotl.n0ano.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

n0ano@n0ano.com wrote:
> On Thu, Oct 16, 2008 at 08:32:53PM -0700, Yinghai Lu wrote:
>> ... 
>> you want to remove earlycon from Documenatation/kernel-parameters.txt?
>>
>> YH
> 
> I want to remove the documentation and also remove the code
> associated with the earlycon `parameter`.  I absolutely want
> to keep the early printk capability but that should be
> controlled by the `console' parameter, there's no need for
> a separate `earlycon' parameter.
> 
you can not remove the code, we need that holder in console section to call code init console.

and you don't need to remove earlycon in doc.

YH

