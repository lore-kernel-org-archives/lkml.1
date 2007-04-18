Return-Path: <linux-kernel-owner+w=401wt.eu-S1754022AbXDRTll@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022AbXDRTll (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 15:41:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754218AbXDRTll
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 15:41:41 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:34747 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753881AbXDRTlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 15:41:39 -0400
Message-ID: <4626746A.9010701@novell.com>
Date: Wed, 18 Apr 2007 12:41:30 -0700
From: Crispin Cowan <crispin@novell.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20060911)
MIME-Version: 1.0
To: James Morris <jmorris@namei.org>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Andi Kleen <andi@firstfloor.org>,
       Casey Schaufler <casey@schaufler-ca.com>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: AppArmor FAQ
References: <20070417181016.GA10903@one.firstfloor.org> <657751.18080.qm@web36614.mail.mud.yahoo.com> <20070417211653.GB11944@one.firstfloor.org> <20070417225815.000b0fdb@the-village.bc.nu> <Line.LNX.4.64.0704180935100.25495@d.namei>
In-Reply-To: <Line.LNX.4.64.0704180935100.25495@d.namei>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

James Morris wrote:
> On Tue, 17 Apr 2007, Alan Cox wrote:
>   
>> I'm not sure if AppArmor can be made good security for the general case,
>> but it is a model that works in the limited http environment
>> (eg .htaccess) and is something people can play with and hack on and may
>> be possible to configure to be very secure.
>>     
> Perhaps -- until your httpd is compromised via a buffer overflow or 
> simply misbehaves due to a software or configuration flaw, then the 
> assumptions being made about its use of pathnames and their security 
> properties are out the window.
>   
How is it that you think a buffer overflow in httpd could allow an
attacker to break out of an AppArmor profile? This is exactly what
AppArmor was designed to do, and without specifics, this is just FUD.

> Without security labeling of the objects being accessed, you can't protect 
> against software flaws, which has been a pretty fundamental and widely 
> understood requirement in general computing for at least a decade.
>   
Please explain why labels are necessary for effective confinement. Many
systems besides AppArmor have used non-label schemes for effective
confinement: TRON, Janus, LIDS, Systrace, BSD Jail, EROS, PSOS, KeyOS,
AS400, to name just a few. This claim seems bogus. Labels may be your
method of choice for confinement, but they are far from the only way.

Crispin

-- 
Crispin Cowan, Ph.D.               http://crispincowan.com/~crispin/
Director of Software Engineering   http://novell.com

