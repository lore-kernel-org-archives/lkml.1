Return-Path: <linux-kernel-owner+w=401wt.eu-S1753026AbYJVDLn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753026AbYJVDLn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 23:11:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751226AbYJVDLf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 23:11:35 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:7582 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022AbYJVDLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 23:11:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ZamE9qKN6IAcimFxPzb7w9doewRDDtBVjMEm1Cgzz8MFfc0xL1oyrYYGAXw1mrThrt
         5FN9yyAn2jxElgWSUjrn1WtcnxCiIQT2mkDA4wOYlDm0qB1B2FkPDzilPkiwIaKpx2C7
         FrZ3F+Zr/T5+OfbAmE3E/PTjzdCu9RGWsJI7k=
Message-ID: <8bd0f97a0810212011o2dfc2290ra6b227fec3d89a57@mail.gmail.com>
Date: Tue, 21 Oct 2008 23:11:33 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Bryan Wu" <bryan.wu@analog.com>
Subject: Re: [RFC] CRIS: Move header files from include to arch/cris
Cc: "Jesper Nilsson" <jesper.nilsson@axis.com>,
       "Sam Ravnborg" <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>,
       "Mikael Starvik" <mikael.starvik@axis.com>
In-Reply-To: <48FE91AE.4010009@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081021164211.GG24715@axis.com>
	 <8bd0f97a0810211046n2e32868fu1a58cc9123da7c6d@mail.gmail.com>
	 <48FE91AE.4010009@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2008 at 22:36, Bryan Wu wrote:
> Mike Frysinger wrote:
>> On Tue, Oct 21, 2008 at 12:42, Jesper Nilsson wrote:
>>> That means that the machine dependent header files are moved to
>>> arch/cris/mach-{fs,a3}/include, while the common and architecture
>>> dependent files are moved to arch/cris/include.
>>>
>>> It is mainly this I'd like some input on, since most other ports
>>> that have moved their header files have put all headers in
>>> arch/*/include.
>>
>> that seems like a fairly obvious good idea to me ... i'm thinking we
>> should do it for Blackfin as well ...
>
> For moving machine header files to arch/blackfin/include/asm/mach-bf{527,
> 533, 537, 538, 548, 561},  we need to set a link such as
>  arch/blackfin/include/asm/mach -> arch/blackfin/include/asm/mach-bf527,
> because tons of drivers use the header file <asm/mach/xxxx.h>.

i dont think a ton of drivers use asm/mach/xxx.h considering how few
files we have in there.  a transition would be pretty trivial.

> But we don't like to setup a link that is the one reason we move our header
> file from include/asm-blackfin to our arch/blackfin/include/asm.

$arch/include/asm/ and $arch/asm/ would work the same.  just tweak the
actual -I path.
-mike
