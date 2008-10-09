Return-Path: <linux-kernel-owner+w=401wt.eu-S1758165AbYJIGTQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758165AbYJIGTQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 02:19:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755934AbYJIGTA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 02:19:00 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:58247 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754180AbYJIGS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 02:18:59 -0400
Date: Thu, 9 Oct 2008 15:18:40 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Kentaro Takeda <takedakn@nttdata.co.jp>
Cc: Stephen Smalley <sds@tycho.nsa.gov>, James Morris <jmorris@namei.org>,
       Chris Wright <chrisw@sous-sol.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       David Howells <dhowells@redhat.com>,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       Toshiharu Harada <haradats@nttdata.co.jp>,
       Andrew Morton <akpm@linux-foundation.org>,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: Re: [TOMOYO #10 (linux-next) 4/8] Memory and pathname management
 functions.
Message-Id: <20081009151840.ac066cc6.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20081009042917.949002170@nttdata.co.jp>
References: <20081009042814.398846861@nttdata.co.jp>
	<20081009042917.949002170@nttdata.co.jp>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

a nitpick.

On Thu, 09 Oct 2008 13:28:18 +0900
Kentaro Takeda <takedakn@nttdata.co.jp> wrote:

> +static unsigned int allocated_memory_for_savename;
> +static unsigned int quota_for_savename;
> +
> +#define MAX_HASH 256
> +
Maybe based on typical workload and usage but
It's better to write why hash size is fixed size of "256", when you
use hash. 

Thanks,
-Kame

