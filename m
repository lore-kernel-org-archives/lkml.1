Return-Path: <linux-kernel-owner+w=401wt.eu-S1754127AbYJQDdJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127AbYJQDdJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 23:33:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752095AbYJQDcz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 23:32:55 -0400
Received: from rv-out-0506.google.com ([209.85.198.226]:65045 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074AbYJQDcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 23:32:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=gX5Jkg354BdDCCwvea/MZ4Ige7YtwL4/zNvNtj3ZuR2j0t80eCfHYrTUbfN7wrpoHx
         5w2ilxDmmP99KsJ+aTTch0vK1/WMxa7QjPeXSBQ2tX9vZD+sfY7yyl0cENpaFwSzcArQ
         dKr78EBp1QT+7dBDv6GL+f+rkxDYMTMWx+42Q=
Message-ID: <86802c440810162032i25d7af9dk6fb8782b534e16d1@mail.gmail.com>
Date: Thu, 16 Oct 2008 20:32:53 -0700
From: "Yinghai Lu" <yinghai@kernel.org>
To: n0ano@n0ano.com
Subject: Re: [PATCH] Enable console on PCI serial devices
Cc: "Paul Bolle" <pebolle@tiscali.nl>, donald.d.dugger@intel.com,
       linux-kernel@vger.kernel.org, "Alan Cox" <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <20081017024544.GB9378@xolotl.n0ano.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <86802c440810141539x97ceaa4meaab109fae3d9d4c@mail.gmail.com>
	 <1224061999.25929.7.camel@test.thuisdomein>
	 <20081015204850.GC14490@xolotl.n0ano.com>
	 <1224153822.3587.23.camel@test.thuisdomein>
	 <48F76A8B.6050306@kernel.org>
	 <20081016171218.GD14490@xolotl.n0ano.com>
	 <48F785B0.7000008@kernel.org>
	 <20081016182556.GE14490@xolotl.n0ano.com>
	 <86802c440810161130x304128faj6b1a1a6e1b90ed03@mail.gmail.com>
	 <20081017024544.GB9378@xolotl.n0ano.com>
X-Google-Sender-Auth: 99d4386cd94097f6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2008 at 7:45 PM,  <n0ano@n0ano.com> wrote:
> On Thu, Oct 16, 2008 at 11:30:17AM -0700, Yinghai Lu wrote:
>>...
>> but if someone don't need the switch from early console to normal console...
>>
>
> When would that ever be useful?  I can understand wanting early printks
> and normal console printks going to the serial device.  I can understand
> wanting neither to go to serial.  I just don't see why you would ever
> want the early printks to go to serial and then stop using the serial
> for normal console printks, that just doesn't make sense.

you want to remove earlycon from Documenatation/kernel-parameters.txt?

YH
