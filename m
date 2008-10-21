Return-Path: <linux-kernel-owner+w=401wt.eu-S1754755AbYJUTX7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755AbYJUTX7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 15:23:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751997AbYJUTXu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 15:23:50 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:54825 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890AbYJUTXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 15:23:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=voEa6lHJpZ2w39/eOTdWVYKntdvnynJQJraXCbJATjLYhxoWHJSy6w7q+VYhbbwjXb
         2OGeWV+GfKzvDZ3Vt8iJ459OxlPa86AJDp0rxUmGIruijfutwI4JXkL3e82jiPe8RE3F
         IzOS+aEY/V4apQ2ai/YaUhENVexjcdN1Qayt0=
Message-ID: <8bd0f97a0810211223j3b261e18m31127bdc8eb62cc5@mail.gmail.com>
Date: Tue, 21 Oct 2008 15:23:49 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Jesper Nilsson" <Jesper.Nilsson@axis.com>
Subject: Re: [RFC] CRIS: Move header files from include to arch/cris
Cc: "Sam Ravnborg" <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>,
       "Mikael Starvik" <mikael.starvik@axis.com>,
       "Bryan Wu" <Bryan.Wu@analog.com>
In-Reply-To: <20081021191736.GH24715@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081021164211.GG24715@axis.com>
	 <8bd0f97a0810211046n2e32868fu1a58cc9123da7c6d@mail.gmail.com>
	 <20081021191736.GH24715@axis.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2008 at 15:17, Jesper Nilsson wrote:
> On Tue, Oct 21, 2008 at 07:46:18PM +0200, Mike Frysinger wrote:
>> On Tue, Oct 21, 2008 at 12:42, Jesper Nilsson wrote:
>> > That means that the machine dependent header files are moved to
>> > arch/cris/mach-{fs,a3}/include, while the common and architecture
>> > dependent files are moved to arch/cris/include.
>> >
>> > It is mainly this I'd like some input on, since most other ports
>> > that have moved their header files have put all headers in arch/*/include.
>>
>> that seems like a fairly obvious good idea to me ... i'm thinking we
>> should do it for Blackfin as well ...
>
> I'm still not decided, my main reason for following Blackfin and ARM
> was that it seemed good to collect all mach-specific files in one place
> in the tree.
>
> However, keeping them in the same place makes it easy to grep through,
> something I use quite frequently.

when i grep for stuff, i often spend time doing both include/asm-$arch
and arch/$arch rather than looking only at headers or only at source
files ... so how things are organized below arch/$arch wouldnt affect
that aspect of how i work ...
-mike
