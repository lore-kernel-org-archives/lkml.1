Return-Path: <linux-kernel-owner+w=401wt.eu-S1754870AbXJ1QMn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870AbXJ1QMn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 12:12:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751072AbXJ1QMg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 12:12:36 -0400
Received: from gw.goop.org ([64.81.55.164]:34258 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751240AbXJ1QMf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 12:12:35 -0400
Message-ID: <4724B4F2.7070500@goop.org>
Date: Sun, 28 Oct 2007 09:12:34 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Adrian Bunk <bunk@kernel.org>, Kir Kolyshkin <kir@swsoft.com>,
       containers@lists.osdl.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       kir@openvz.org
Subject: Re: [Devel] [PATCH] pidns: Place under CONFIG_EXPERIMENTAL (take
 2)
References: <CBC546DD07068244AEC110EFEDA58B7235893F@excite.int.sw-soft.com>	<m1ve8ty1tq.fsf@ebiederm.dsl.xmission.com>	<20071027002448.GH30533@stusta.de> <m18x5puyw7.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m18x5puyw7.fsf@ebiederm.dsl.xmission.com>
X-Enigmail-Version: 0.95.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Roughly that sounds like CONFIG_EXPERIMENTAL to me.  But I would
> be happy to hear if someone has a better idea.
>   

Rather than overload an existing config option, why not add one with the
specific semantics you want: CONFIG_UNSTABLE_UABI.  The problem seems
like one which which may occur again, though one hopes not too often.  I
guess the risk is that people will leave their subsystems depending on
it permanently (sysfs?), so it ends up being set all the time and
becomes as useless as EXPERIMENTAL...

    J
