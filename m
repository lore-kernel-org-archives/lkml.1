Return-Path: <linux-kernel-owner+w=401wt.eu-S1764995AbXFGPm5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764995AbXFGPm5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 11:42:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764805AbXFGPmn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 11:42:43 -0400
Received: from web36605.mail.mud.yahoo.com ([209.191.85.22]:21232 "HELO
	web36605.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1764768AbXFGPml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 11:42:41 -0400
X-YMail-OSG: k6nbvOgVM1kceyalr0eO14V35wkwIBMef.0VJFdu1IhRDWVvTs7T3ArboGYCvHgco1vRf9nEKIImO6ENBwOe5S6Mdt75l6UUqYYIgorE2ntXkbXq4yU-
X-RocketYMMF: rancidfat
Date: Thu, 7 Jun 2007 08:42:40 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH] Audit: Add TTY input auditing
To: Steve Grubb <sgrubb@redhat.com>, Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Miloslav Trmac <mitr@redhat.com>, dwmw2@infradead.org,
       linux-kernel@vger.kernel.org, Alan Cox <alan@redhat.com>,
       Alexander Viro <aviro@redhat.com>
In-Reply-To: <200706070650.50100.sgrubb@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <817517.5859.qm@web36605.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Steve Grubb <sgrubb@redhat.com> wrote:

> On Thursday 07 June 2007 04:13:42 Jan Engelhardt wrote:
> > >Add TTY input auditing, used to audit system administrator's actions.
> >
> > _What_ exactly does it audit?
> 
> In theory, it should audit the actions performed by the sysadmin. This patch 
> doesn't cover actions done via X windows interface.
> 
> > And why does it only audit sysadmin actions?
> 
> This is what's called out for in various security standards such as NISPOM, 
> DCID 6/3, and PCI. Its all about non-repudiation.
> 
> > Is this supposed to be a keylogger?
> 
> Sort of. Its supposed to allow the Security Officer the ability to check on 
> what an admin was doing if they were found to be attempting access to 
> information outside their duties. Or if something is found to be 
> misconfigured, they can backtrack and see how it became that way if that was 
> important.
> 
> Some people try to be compliant with these security standards with user space
>  
> tools like rootsh, but that is too easy to detect and defeat. And then it 
> does not put its data into the audit system where its correlated with other 
> system events. 

The evaluation teams that I have worked with (OrangeBook and CC)
as well as their technical advisory groups have always been clear
that keyboard logging is not an appropriate mechanism for security
audit logging. There is insufficient correlation between what is
typed and security relevent actions for keyboard (or mouse event)
logging to meet the audit requirements. You have to log what happened.
Logging what was requested is insufficient and logging what was
typed, which may or may not have resulted in an actual request is
not helpful to meeting security audit requirements.

> >What about tty output?
> 
> That is not required.
> 
> -Steve
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 
> 


Casey Schaufler
casey@schaufler-ca.com
