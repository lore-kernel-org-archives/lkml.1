Return-Path: <linux-kernel-owner+w=401wt.eu-S1758822AbZFBD7w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758822AbZFBD7w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 23:59:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756798AbZFBD7l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 23:59:41 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:59749 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752933AbZFBD7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 23:59:40 -0400
Date: Mon, 1 Jun 2009 23:05:38 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] Move sleeping operations to outside the semaphore.
Message-ID: <20090602040538.GA21698@hallyn.com>
References: <200906020141.n521faqb003256@www262.sakura.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906020141.n521faqb003256@www262.sakura.ne.jp>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Tetsuo Handa (penguin-kernel@i-love.sakura.ne.jp):
> TOMOYO is using rw_semaphore for protecting list elements.
> But TOMOYO is doing operations which might sleep inside down_write().
> This patch makes TOMOYO's sleeping operations go outside down_write().

Hi Tetsuo,

another thing making these patches hard for me to review is the lack of
documentation to start with.  There are lists of policy managers, domain
initializers, etc, and I don't know what they are.

Could you flesh out Documentation/tomoyo.txt and/or the variable, struct,
and function definitions under security/tomoyo/ with some explanations?

(A fn comment like
	* tomoyo_update_manager_entry - Add a manager entry.
is not helpful)

That should help me sound less ignorant in the future...

thanks,
-serge
