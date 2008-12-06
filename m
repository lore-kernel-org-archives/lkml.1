Return-Path: <linux-kernel-owner+w=401wt.eu-S1756470AbYLFMCZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756470AbYLFMCZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 07:02:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754603AbYLFMCQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 07:02:16 -0500
Received: from mail-gx0-f18.google.com ([209.85.217.18]:46759 "EHLO
	mail-gx0-f18.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331AbYLFMCP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 07:02:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=hTao3Bqscd8LKGzTPHj8JAIbULVANwX2Q5ThE1s4zcUcqxuzEk6OLn/cO/IwmHZi4F
         IB030UbdM92PM84gbt7eABXGaOw33sxhGi4HSwBzp5F1RvwX7bm5nZDsMaWjuvyDiiwk
         E2wjL+pC0mRX5xvJixRrHMw1QGMpthrq4roxc=
Message-ID: <fbdd0e50812060402q6aaaed6q6bb345c50ed68b07@mail.gmail.com>
Date: Sat, 6 Dec 2008 13:02:14 +0100
From: Geralt <usr.gentoo@googlemail.com>
To: Valdis.Kletnieks@vt.edu,
       "=?ISO-8859-1?Q?Am=E9rico_Wang?=" <xiyou.wangcong@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Shebang - why are parameters not splitted on whitespace?
In-Reply-To: <10860.1228542083@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <fbdd0e50812030714md7dd899xeb8940798632b08b@mail.gmail.com>
	 <2375c9f90812030756r5b8840e1u3980ddca8df27a6b@mail.gmail.com>
	 <fbdd0e50812030929q65d2e805y49094dd67209be7e@mail.gmail.com>
	 <fbdd0e50812030929s2d573981k46757c1b706f4cd5@mail.gmail.com>
	 <2375c9f90812051704oa80cafeif17909e332178d6e@mail.gmail.com>
	 <10860.1228542083@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 6, 2008 at 6:41 AM,  <Valdis.Kletnieks@vt.edu> wrote:
> On Sat, 06 Dec 2008 01:04:52 GMT, Américo Wang said:
>> On Wed, Dec 3, 2008 at 5:29 PM, Geralt <usr.gentoo@googlemail.com> wrote:
>> > Hello,
>> >
>> > I should have anticipated this objection :-). I'm aware that this is
>> > not consistent among Unix operating systems (you can find more about
>> > it here [1]), but I was specifically refering to linux in this case
>> > and why it handles the shebang arguments as one big string and not as
>> > single arguments for the application.
>>
>> I can't think out any strong reasons, maybe only becasue Linux developers
>> prefer that approach.
>
> And of course, "whitespace" is a somewhat fungible concept.  'man bash'
> and read about $IFS.
>
So you're saying that you can't do that because you don't know where
to split the parameters, right? But would it be that bad to state a
rule what "whitespace" is in the shebang line?
