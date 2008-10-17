Return-Path: <linux-kernel-owner+w=401wt.eu-S1757054AbYJQRxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757054AbYJQRxv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 13:53:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755982AbYJQRxn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 13:53:43 -0400
Received: from smtp101.prem.mail.sp1.yahoo.com ([98.136.44.56]:28485 "HELO
	smtp101.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755920AbYJQRxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 13:53:43 -0400
X-YMail-OSG: gMwU0qMVM1nlODp2daIRDZP77OmkDmtrN0W1fgUSC056Tl2dgZhE79l6KzZf6SvCj5eipQuVfHhhOTk6.x9fcA7m0L9IEotq20x_b.kcXbcbamMzmHOQMUWucge37olIJT0-
X-Yahoo-Newman-Property: ymail-3
Message-ID: <48F8D122.3010105@schaufler-ca.com>
Date: Fri, 17 Oct 2008 10:53:38 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Tilman Baumann <tilman.baumann@collax.com>
CC: Linux-Kernel <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org
Subject: Re: SMACK netfilter smacklabel socket match
References: <48DBC9A1.20900@collax.com> <48DC5A45.8020801@schaufler-ca.com> <E33DFA86-F040-413F-8156-EDCB879F4CEE@collax.com> <48DDBE2E.3010006@schaufler-ca.com> <48E1007F.4000400@collax.com> <48E19D01.9050809@schaufler-ca.com> <48E35F36.4030203@collax.com> <48E3957A.7040201@schaufler-ca.com> <48E3AB97.8020305@collax.com> <48E3BFDE.7010300@schaufler-ca.com> <48EA0B30.6080907@collax.com> <48EACC91.8040008@schaufler-ca.com> <48F8C3EC.1030607@collax.com>
In-Reply-To: <48F8C3EC.1030607@collax.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tilman Baumann wrote:
> Hi Casey,
>
> the last weeks I tried to come up with some way to circumvent my 
> problems by aimlessly poking around in the code. Did not work though. 
> Not yet at least. :)
> Maybe it makes more sense for me to wait until you have a solution.
> My whole project is stalled right now because of this and I'm not sure 
> what next.
> Do you plan to change something there soon? If so I would stop wasting 
> my time with hopeless attempts.
>
> My problem is at the moment that I don't really know what to do. If 
> you can give some aim I would be glad if I could do something.

Well, the good news is that I have a change under test that will address
your needs, allowing a host or set of hosts to be generally accessible
from the Smack system. The bad news is that it uses a set of netlabel
apis that are not going to get released in favor of a redesigned set of
apis which are not available yet. The good news is that those apis will
handle Smack's needs just fine, but again the bad news is that I don't
have them to use yet.

If you're up to trying out something that you know is going to get
rewhacked before it goes in anywhere let me know.

