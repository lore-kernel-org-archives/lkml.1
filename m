Return-Path: <linux-kernel-owner+w=401wt.eu-S1760212AbYCYX3r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760212AbYCYX3r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 19:29:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755656AbYCYX3i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 19:29:38 -0400
Received: from mx1.suse.de ([195.135.220.2]:40250 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752960AbYCYX3g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 19:29:36 -0400
From: "NeilBrown" <neilb@suse.de>
To: "Al Viro" <viro@ZenIV.linux.org.uk>
Date: Wed, 26 Mar 2008 10:29:27 +1100 (EST)
Message-ID: <34746.192.168.1.70.1206487767.squirrel@neil.brown.name>
In-Reply-To: <20080325224919.GM10722@ZenIV.linux.org.uk>
References: <20080321155451.GU10722@ZenIV.linux.org.uk>
    <E1Jck2N-0001Q3-7W@pomaz-ex.szeredi.hu>
    <20080321163520.GV10722@ZenIV.linux.org.uk>
    <E1JckW9-0001Ub-Rs@pomaz-ex.szeredi.hu>
    <18408.26863.617591.836548@notabene.brown>
    <200803252045.CGB04105.HLSQFOJMtOFVOF@I-love.SAKURA.ne.jp>
    <57096.192.168.1.70.1206484328.squirrel@neil.brown.name>
    <20080325224919.GM10722@ZenIV.linux.org.uk>
Subject: Re: r-o bind in nfsd
Cc: "Tetsuo Handa" <penguin-kernel@i-love.sakura.ne.jp>, miklos@szeredi.hu,
       haveblue@us.ibm.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       hch@infradead.org, linux-security-module@vger.kernel.org,
       jmorris@namei.org
User-Agent: SquirrelMail/1.4.13
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, March 26, 2008 9:49 am, Al Viro wrote:
> On Wed, Mar 26, 2008 at 09:32:08AM +1100, NeilBrown wrote:
>
>> >   (1) The kernel don't know what operation (open/create/truncate etc.)
>> > will be
>> >       done at the moment of link_path_walk().
>>
>> Though the 'indent' data structure could be used to carry this
>> information.
>
> If it's 'intent',

Yes, sorry.

>                   that mess will be gone next cycle.

Cool.  Any chance of a preview?  Is it in -next or -mm ??

>> >   (3) The rename() and link() operations handle two pathnames.
>> >       But, it is not possible to know both pathnames at the moment of
>> >       link_path_walk().
>>
>> Not an insolvable problem.
>> One could imagine an implementation where a TYPE_RENAME_FROM security
>> check produced a cookie that was consumed by a TYPE_RENAME_TO security
>> check.  The cookie could then be used by the security module to
>> make any connection between the two names that might be appropriate.
>
> alt.tasteless.software is that -> way...
>

While I have no desire to defend that particular design, saying "tasteless"
without suggesting an alternate approach does appear somewhat unhelpful.

NeilBrown

