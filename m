Return-Path: <linux-kernel-owner+w=401wt.eu-S1752651Ab0AKBnO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752651Ab0AKBnO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 20:43:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751508Ab0AKBnO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 20:43:14 -0500
Received: from lists.laptop.org ([18.85.2.145]:39607 "EHLO mail.laptop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750755Ab0AKBnN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 20:43:13 -0500
Date: Sun, 10 Jan 2010 20:45:30 -0500
From: Michael Stone <michael@laptop.org>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-security-module@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       David Lang <david@lang.hm>, Oliver Hartkopp <socketcan@hartkopp.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
       Bryan Donlan <bdonlan@gmail.com>, Evgeniy Polyakov <zbr@ioremap.net>,
       "C. Scott Ananian" <cscott@cscott.net>,
       James Morris <jmorris@namei.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Bernie Innocenti <bernie@codewiz.org>,
       Mark Seaborn <mrs@mythic-beasts.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
       Samir Bellabes <sam@synack.fr>,
       Casey Schaufler <casey@schaufler-ca.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>, Pavel Machek <pavel@ucw.cz>,
       Al Viro <viro@ZenIV.linux.org.uk>, Kyle Moffett <kyle@moffetthome.net>,
       Michael Stone <michael@laptop.org>
Subject: Re: [PATCH 2/3] Security: Implement disablenetwork semantics. (v4)
Message-ID: <20100111014530.GB4070@heat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <201001111007.EAG82373.VHFQSLFOFMOOJt@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tetsuo Handa wrote:

>Michael Stone wrote:
>> Examples of software that I want to be able to gain privileges normally include:
>> 
>>    rainbow, which requires privilege in order to add new accounts to the system
>>    and in order to call setuid() but which does not require networking
>>    privileges.
>
> If the system is not using local files (i.e. /etc/passwd and /etc/shadow),
> the process who wants to add new accounts to the system might need network
> access (e.g. to LDAP server), doesn't it?

General purpose account manipulation tools might need network access but
rainbow handles all its account manipulations via state stored in
/var/spool/rainbow/2. This state is made available to the rest of the system
via libnss_rainbow.

Michael
