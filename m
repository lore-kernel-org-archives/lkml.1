Return-Path: <linux-kernel-owner+w=401wt.eu-S1755507AbYISX5j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755507AbYISX5j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 19:57:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752539AbYISX5b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 19:57:31 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:46050 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752258AbYISX5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 19:57:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:references:x-google-sender-auth;
        b=RWQowHGOGCQWTrOfM4LgUMoStVy6MiiA4mIL60L5/p/d07i0hapfpHGo1B0p/I3etV
         LEqhlTBFDLTnGhdAp253TuZy6q7l3E2IYVt3KEICnoTvc18Z/4lPokhRacsWJZ8+o90D
         VamFGXaIVPBV5VC9tV7bo7huNyK4sqCJtPLqE=
Message-ID: <70318cbf0809191657l351f9770w1ad57c7a1888eb70@mail.gmail.com>
Date: Fri, 19 Sep 2008 16:57:28 -0700
From: "Chris Li" <lkml@chrisli.org>
To: "Takashi Iwai" <tiwai@suse.de>
Subject: Re: diet-kconfig: a script to trim unneeded kconfigs
Cc: "Giacomo A. Catenazzi" <cate@cateee.net>,
       "Mauro Carvalho Chehab" <mchehab@infradead.org>,
       "Steven Rostedt" <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
In-Reply-To: <70318cbf0809191655m89e4b4fo68c3693487afed98@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_407_15120327.1221868648717"
References: <s5hbpyny7bl.wl%tiwai@suse.de>
	 <20080918122541.2c3c7b39@areia.chehab.org>
	 <48D27734.3040600@cateee.net>
	 <alpine.LFD.1.10.0809181154020.12224@bombadil.infradead.org>
	 <48D36D02.4090003@cateee.net> <s5hy71oyviu.wl%tiwai@suse.de>
	 <70318cbf0809191655m89e4b4fo68c3693487afed98@mail.gmail.com>
X-Google-Sender-Auth: 6880fdc9b70a6477
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_407_15120327.1221868648717
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Fri, Sep 19, 2008 at 4:55 PM, Chris Li <lkml@chrisli.org> wrote:
> Incidentally, I wrote such a script as well. In 64 lines of python code.
> I attach the script in question in the mail. I use a approach very
> similar to yours. But I work around some of the nasty part.

Oops, I forget to attach the script. Here it is.

Chris

------=_Part_407_15120327.1221868648717
Content-Type: text/x-python-script; name=minmod.py
Content-Transfer-Encoding: base64
X-Attachment-Id: f_flbh5j5h0
Content-Disposition: attachment; filename=minmod.py

IyEvdXNyL2Jpbi9weXRob24KaW1wb3J0IHJlCmltcG9ydCBvcwoKY2xhc3MgS2J1aWxkOgoJZGVm
IF9faW5pdF9fKHNlbGYsIHJvb3QpOgoJCXNlbGYucm9vdCA9IHJvb3QgCgkJc2VsZi5jb25mcyA9
IHt9CSMgZGljdCBvZiBsaXN0cwoJCXNlbGYubW9kdWxlcyA9IHt9CgoJCXNlbGYucmVhZF9rYnVp
bGQoKQoKCWRlZiBhbGxfa2J1aWxkKHNlbGYpOgoJCWNtZCA9ICdmaW5kIC4gJ1wKCQkgICAgICAn
IC1yZWdleCAiJXMvW2Etel0uKi9cXChNYWtlZmlsZVxcfEtidWlsZFxcKSInIFwKCQkgICAgICAn
IC1ub3QgLXJlZ2V4ICIuKi9cKCcgXAoJCSAgICAgICdhcmNoXHxEb2N1bWVudHNcfGZpcm13YXJl
XHxzY3JpcHRzXHxyYWlkNnRlc3RcKS8uKiInIFwKCQkgICAgICAlIHNlbGYucm9vdAoJCXJldHVy
biBvcy5wb3BlbihjbWQpLnJlYWQoKS5zcGxpdCgpCgoJZGVmIHJlYWRfa2J1aWxkKHNlbGYpOgoJ
CWFsbGZpbGUgPSBbb3BlbihmKS5yZWFkKCkgZm9yIGYgaW4gc2VsZi5hbGxfa2J1aWxkKCldCgkJ
ZGF0YSA9ICJcbiIuam9pbihhbGxmaWxlKQoJCWRhdGEgPSByZS5zdWIociIoP20pXmlmZXFccytc
KFwkXCgoQ09ORklHX1xTKylccypcKSxccyptXCkuKiIsCgkJCQlyIm9iai0kKFwxKSBcXCIsIGRh
dGEpCgkJZGF0YSA9IHJlLnN1YihyIig/bSlcXFxuXHMqfG9iai1tICIsICcnLCBkYXRhKQoJCWFs
bCA9IHJlLmZpbmRhbGwoIHIiKD9tKW9iai1cJFwoKENPTkZJR19cUyspXClccypbOitdPSguKiki
LCBkYXRhKQoJCXNlbGYuZGF0YSA9IGRhdGEKCQlmb3IgKGNvbmYsIG1vZHVsZXMpIGluIGFsbDoK
CQkJbW9kcyA9IHJlLmZpbmRhbGwociIoXFMrKVwubyIsIG1vZHVsZXMpCgkJCWZvciBtIGluIG1v
ZHM6CgkJCQltID0gcmUuc3ViKCItIiwiXyIsbSkKCQkJCSNwcmludCBjb25mLCAiLT4iLCBtCgkJ
CQlzZWxmLmNvbmZzLnNldGRlZmF1bHQoY29uZiwgW10pLmFwcGVuZChtKQoJCQkJc2VsZi5tb2R1
bGVzLnNldGRlZmF1bHQobSwgW10pLmFwcGVuZChjb25mKQoJZGVmIHJlYWRfbW9kdWxlcyhzZWxm
KToKCQlkYXRhID0gb3BlbigiL3Byb2MvbW9kdWxlcyIpLnJlYWQoKQoJCXJldHVybiByZS5maW5k
YWxsKHIiKD9tKV5cUysiLCBkYXRhKQoKCWRlZiB0ZXN0X21vZHVsZShzZWxmLCBtKToKCQlhbGws
IGNvbmYgPSBtLmdyb3VwKDAsMSkKCQlpZiBjb25mIGluIHNlbGYuY29uZnM6CgkJCXJldHVybiAi
IyAlcyBpcyBub3Qgc2V0IiVjb25mCgkJcmV0dXJuIGFsbAoKCWRlZiBmaWx0ZXIoc2VsZiwgY29u
ZmlnKToKCQkjcHJpbnQgc2VsZi5kYXRhCgkJZm9yIG0gaW4gc2VsZi5yZWFkX21vZHVsZXMoKToK
CQkJaWYgbm90IHNlbGYubW9kdWxlcy5oYXNfa2V5KG0pOgoJCQkJcHJpbnQgbSwiOiBVa25vd24g
bW9kdWxlLCBtYXkgYmUgZmlyZW13YXJlPyIKCQkJCWNvbnRpbnVlCgkJCWZvciBjIGluIHNlbGYu
bW9kdWxlc1ttXToKCQkJCWlmIGMgaW4gc2VsZi5jb25mczoKCQkJCQlkZWwgc2VsZi5jb25mc1tj
XQoJCWRhdGEgPSBvcGVuKGNvbmZpZykucmVhZCgpCgkJZGF0YSA9IHJlLnN1YihyIig/bSleKENP
TkZJR19cUyspPW0iLCBzZWxmLnRlc3RfbW9kdWxlLCBkYXRhKQoJCW91dCA9IGNvbmZpZyArICIu
bWluIgoJCXByaW50ICJXcml0aW5nIG5ldyBjb25maWcgdG86Iiwgb3V0CgkJb3BlbihvdXQsICJ3
Iikud3JpdGUoZGF0YSkKCQkJCmRlZiBtYWluKCk6CglrYnVpbGQgPSBLYnVpbGQoIi4iKQoJa2J1
aWxkLmZpbHRlcigiLmNvbmZpZyIpCm1haW4oKQo=
------=_Part_407_15120327.1221868648717--
