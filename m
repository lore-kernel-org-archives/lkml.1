Return-Path: <linux-kernel-owner+w=401wt.eu-S1758135AbYFLU6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758135AbYFLU6T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 16:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754522AbYFLU6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 16:58:09 -0400
Received: from outbound-mail-120.bluehost.com ([69.89.18.6]:56419 "HELO
	outbound-mail-120.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754496AbYFLU6I convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 16:58:08 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Justin Madru <jdm64@gawab.com>
Subject: Re: [regression?] Sometime (often) X come out blank (black screen) on cold boot - Intel chipset
Date: Thu, 12 Jun 2008 13:58:00 -0700
User-Agent: KMail/1.9.9
Cc: Romano Giannetti <romanol@upcomillas.es>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, lkml <linux-kernel@vger.kernel.org>,
       =?utf-8?q?Sa=C3=AFvann_Carignan?= <oxmosys@gmail.com>
References: <1213101501.21041.9.camel@pern> <484F5582.5000805@gawab.com>
In-Reply-To: <484F5582.5000805@gawab.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200806121358.01514.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, June 10, 2008 9:33 pm Justin Madru wrote:
> Jesse,
>     It seems the problem might be related to usplash. In each reported
> case Ubuntu and usplash were used, and disabling usplash (at least for
> me) seems to fix the problem. Could there be some timing feature that
> usplash uses that isn't guaranteed/changed with some optimizations of
> CFS (or HR-timers) that went into 2.6.25? I've cc'ed Saïvann Carignan,
> who seems to be the most active contributer to usplash.

Yeah, usplash really seems to affect things to make the bug more visible, but 
I still suspect a timing bug in xf86-video-intel...  Unfortunately those are 
hard to find & debug, but we're working on some related stuff, so hopefully 
we'll find & fix it soon.

Thanks,
Jesse
