Return-Path: <linux-kernel-owner+w=401wt.eu-S1161333AbXEDVPv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161333AbXEDVPv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 17:15:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161338AbXEDVPu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 17:15:50 -0400
Received: from netblock-66-245-252-131.dslextreme.com ([66.245.252.131]:36957
	"EHLO Angel.zoy.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161333AbXEDVPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 17:15:49 -0400
Date: Fri, 4 May 2007 14:15:48 -0700
From: Michel Lespinasse <walken@zoy.org>
To: "Kok, Auke" <auke-jan.h.kok@intel.com>
Cc: Chuck Ebbert <cebbert@redhat.com>, linux-kernel@vger.kernel.org,
       Dave Jones <davej@redhat.com>, Jeb Cramer <cramerj@intel.com>,
       John Ronciak <john.ronciak@intel.com>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>,
       Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: Re: e1000 issue on DQ965GF board (was 24 lost ticks with 2.6.20.10  kernel)
Message-ID: <20070504211548.GA21017@zoy.org>
References: <20070501130715.GB29131@zoy.org> <46375E04.5030506@redhat.com> <20070501214912.GA4048@zoy.org> <4637BA70.8000108@intel.com> <20070502084146.GA6089@zoy.org> <4638D51C.7010603@intel.com> <20070503062701.GA22255@zoy.org> <463B7AA7.9050302@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <463B7AA7.9050302@intel.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 04, 2007 at 11:25:43AM -0700, Kok, Auke wrote:
> can you try turning off the "management enable" function in the BIOS of the 
> DQ965GF? That fixes this issue for us in our labs. A fix for this is also 
> available in our standalone 7.5.5.1 driver (obtainable from e1000.sf.net), 
> but it hasn't made it upstream yet.

Done. Indeed, this fixed the issue. Thanks!

The interesting thing is that I *thought* I had it off, as I had never
touched this menu or set a password on it. The manual said that the board
would not be accessible from the network until I set a password, which I
had (incorrectly) assumed to mean the ME feature would be off. To turn off
the option (or even see I had it on) I had to google for the default
ME password, which turned out to be 'admin'.

Thanks for the help,

-- 
Michel "Walken" Lespinasse
"Bill Gates is a monocle and a Persian cat away from being the villain
in a James Bond movie." -- Dennis Miller
