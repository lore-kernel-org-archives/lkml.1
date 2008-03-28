Return-Path: <linux-kernel-owner+w=401wt.eu-S1756787AbYC1Tom@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756787AbYC1Tom (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 15:44:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754242AbYC1Tod
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 15:44:33 -0400
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:26985 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754233AbYC1Toc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 15:44:32 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=qdXDtw5eZiJ5uW7ykQsbY0WNLl9cvbdt3AJHFMaYMVS1xLuoapA3YlFruqrqBwQY7j6d0jBfbEQ/uEr79/QQNmFWFED00UHDotV2tvM8PziSbA6aWL3yXth0rhMHhS4o6tXmDQEnL90aq7BaJrbuU0J1+A1wKPerUfOVi3XdFsM=  ;
X-YMail-OSG: r.d2a9sVM1nzctbMSEINOb5wxQQXZ_dmguIXReMeNyh.bD_083fAJTIWb8PjfzjUM08OSpIsag--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Subject: Re: 2.6.25 regression: powertop says 120K wakeups/sec
Date: Fri, 28 Mar 2008 12:44:26 -0700
User-Agent: KMail/1.9.6
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-acpi@vger.kernel.org,
       "Len Brown" <lenb@kernel.org>
References: <20080322202454.9D69DCC0EF@adsl-69-226-248-13.dsl.pltn13.pacbell.net> <200803281201.54380.david-b@pacbell.net> <924EFEDD5F540B4284297C4DC59F3DEEC83CDD@orsmsx423.amr.corp.intel.com>
In-Reply-To: <924EFEDD5F540B4284297C4DC59F3DEEC83CDD@orsmsx423.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803281244.27012.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 28 March 2008, Pallipadi, Venkatesh wrote:

> >> > I noticed this with 2.6.25-rc2 (if not before), and the problem
> >> > is still there with 2.6.25-rc6-git (as of this AM).
> >
> >A 2.6.24 kernel I still had stashed away didn't act odd; the
> >problem joined us before 2.6.25-rc1 was tagged.
> >
> 
> There was a fix that went in recently (one or two days back) that should
> have fixed this.
> Commit 8e92b6605da989
> 
> Can you check with latest git to see whether this is still a problem?

The problem is still there in GIT as of this morning, which
includes 8e92b6605da989 ...

Comments on why bc71bec91f9875ef825d12104acf3bf4ca215fa4 seems
to be causing this?  I think it's just bad reports getting to
userspace, rather than an actual 120K wakeups/second.  (The
report is of course not always 120K, but it's usually in that
range.)

- Dave
