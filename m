Return-Path: <linux-kernel-owner+w=401wt.eu-S1754185AbZG0TVx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185AbZG0TVx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 15:21:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753124AbZG0TVw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 15:21:52 -0400
Received: from web50111.mail.re2.yahoo.com ([206.190.39.137]:41669 "HELO
	web50111.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751326AbZG0TVw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 15:21:52 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Mon, 27 Jul 2009 15:21:51 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=kltoUeBqH9r59LHlmsC08viSsJTtlgM+MAd7+p2qfJSI8BBINy81aeXFf8uLGdXauLU0W90cPLU4ys7CCZDbAYAqDhkDFC3umOuKx9Q5a72tQTJeSh/zJJUXUiLhJZzoUGhIdkPVX9yUhXjraQDgCe7sYyk+FyqW0SZCMhzznRg=;
Message-ID: <844900.87437.qm@web50111.mail.re2.yahoo.com>
X-YMail-OSG: TmbCdnsVM1kkqdIkK5rm0WJpqs2yaa.9BUIfg6sY.mwDltqd4JtESNAvcwN1.uEAC28FU0PA.xMnHloqugVQdMrJLqf08GZ2vHrUZPh48dI.8G4zMl2JO7bBVNkt72kv19fUrVm8oHEKZ1peyhgKfWYzQpp3KUFv7qD.S91JhH88RpZ3hwlYTM83tFTKJv0_t30tg1pQ4mxShyMuqWRTT8sK9sgt2PCNVl9I.Oy7cRtrcIBG4Rm7BvpWIKUGlq3BV4zCe93Hb86zuCbxdLeR6.jN9uPNieATmWbLheWkFsDGl94y_7J6vkrZyd71u2XIY_HpglGrqq9L3cV2.3uV3qtGt_c-
X-Mailer: YahooMailClassic/6.0.19 YahooMailWebService/0.7.338.1
Date: Mon, 27 Jul 2009 12:15:12 -0700 (PDT)
From: Doug Thompson <norsk5@yahoo.com>
Subject: Re: [PATCH] amd64_edac: fix insmod fail while ecc is enabled
To: Borislav Petkov <petkovbb@googlemail.com>
Cc: dougthompson@xmission.com, borislav.petkov@amd.com,
       wan wei <onewayforever@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20090727184302.GC3044@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--- On Mon, 7/27/09, Borislav Petkov <petkovbb@googlemail.com> wrote:

> From: Borislav Petkov <petkovbb@googlemail.com>
> Subject: Re: [PATCH] amd64_edac: fix insmod fail while ecc is enabled
> To: "Doug Thompson" <norsk5@yahoo.com>
> Cc: dougthompson@xmission.com, borislav.petkov@amd.com, "wan wei" <onewayforever@gmail.com>, linux-kernel@vger.kernel.org
> Date: Monday, July 27, 2009, 12:43 PM
> Hi,
> 
> On Mon, Jul 27, 2009 at 11:01:26AM -0700, Doug Thompson
> wrote:
> > In a prior email you indicated that you refactored the
> function in
> >question. What that in the series of patches you
> submitted? I think
> >that set is too big to get in the RC branch.
> >
> > We need this in 2.6.31 in order for the module to even
> work.
> >
> > Shall we push my simple one, or your complete
> refactor?
> 
> I wanted to give my refactoring patch a little testing in
> linux-next but
> my gut feeling tells me it would be wiser to go with your
> fix that late
> in the cycle and postpone mine for the next kernel. In the
> meantime,
> it'll see more testing in linux-next.
> 
> I'll push the two fixes tomorrow if Linus hasn't pulled yet

great, thanks. Since I am going camping on wednesday until next monday, I am short on access let alone time. If you will handle it, that is wonderful

doug t

> otherwise
> I'll have to wait for -rc6 with your patch, but even
> that'll do.
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
