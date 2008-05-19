Return-Path: <linux-kernel-owner+w=401wt.eu-S1764191AbYESWcq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764191AbYESWcq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 18:32:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755068AbYESWci
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 18:32:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:40623 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755950AbYESWch (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 18:32:37 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: "Jeff Chua" <jeff.chua.linux@gmail.com>
Subject: Re: recent 2.6.26 kernel hangs at suspend
Date: Mon, 19 May 2008 18:30:49 -0400
User-Agent: KMail/1.9.9
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>,
       "Arjan van de Ven" <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, "Shaohua Li" <shaohua.li@intel.com>,
       "Greg KH" <greg@kroah.com>
References: <b6a2187b0805190807o7f6e87e1nd883607d603c893b@mail.gmail.com> <200805191438.53323.lenb@kernel.org> <b6a2187b0805191525m5854c35aof52f40a337e67510@mail.gmail.com>
In-Reply-To: <b6a2187b0805191525m5854c35aof52f40a337e67510@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805191830.49852.lenb@kernel.org>
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0rc1 (hera.kernel.org [140.211.167.34]); Mon, 19 May 2008 22:31:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 19 May 2008, Jeff Chua wrote:
> On Tue, May 20, 2008 at 2:38 AM, Len Brown <lenb@kernel.org> wrote:
> > On Monday 19 May 2008, Jeff Chua wrote:
> 
> > Does this notebook have intel graphics?
> 
> Yes.
> 
> (II) intel(0): Integrated Graphics Chipset: Intel(R) 945GM
> 
> > If yes, does anything change with the i915 driver loaded vs not loaded?
> 
> I'll try that. Currently, everything compliled into kernel.


Another thing to check out is if VT switching is working.
On the Toshiba U305, which also has Intel graphics, it broke
and made suspend/resume look broken:

http://bugzilla.kernel.org/show_bug.cgi?id=10620
