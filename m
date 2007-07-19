Return-Path: <linux-kernel-owner+w=401wt.eu-S939889AbXGSQgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939889AbXGSQgU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 12:36:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932669AbXGSQgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 12:36:09 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:54576 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764159AbXGSQgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 12:36:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:subject:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=gHl4SX9hR1hnXT2ef6DnyuJYsIbc8WMDNpPEN9EmEw69UhOA+t6ISSg1S+3Tf7wPoxN+EIWprQXgo75U/lE7HEikYI0OFlEI3fS8ZHnsOGm/2Mi1JNFLUI50M9yKQW2b3LNydTe2hDq4nW2i+COsUGBIPctuKhf2cGGgMYucAjo=
Message-ID: <469F92A1.5070203@googlemail.com>
Date: Thu, 19 Jul 2007 18:34:41 +0200
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Gabriel C <nix.or.die@googlemail.com>,
       Jeremy Fitzhardinge <jeremy@xensource.com>,
       Satyam Sharma <satyam.sharma@gmail.com>, Tejun Heo <htejun@gmail.com>,
       Avi Kivity <avi@qumranet.com>,
       =?UTF-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
	<ukleinek@informatik.uni-freiburg.de>,
       Jens Axboe <axboe@suse.de>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       dri-devel@lists.sourceforge.net, Dave Airlie <airlied@linux.ie>,
       =?UTF-8?B?TWljaGVsIETDpG56ZXI=?= <michel@tungstengraphics.com>,
       =?UTF-8?B?S3Jpc3RpYW4gSMO4Z3NiZXJn?= <krh@redhat.com>,
       Charles Gagalac <charles.gagalac@gmail.com>
Subject: [1/2] 2.6.22-git: known regressions
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here is a list of some known regressions in 2.6.22-git.

Feel free to add new regressions/remove fixed etc.
http://kernelnewbies.org/known_regressions

List of Aces

Name                    Regressions fixed since 21-Jun-2007
Adrian Bunk                            3
Andi Kleen                             2
Andrew Morton                          2
David Woodhouse                        2
Hugh Dickins                           2
Jens Axboe                             2



Unclassified

Subject         : a52b1752c07 broke !SMP: error: implicit declaration of function `WARN_ON'
References      : http://lkml.org/lkml/2007/7/17/600
Last known good : ?
Submitter       : Uwe Kleine-König <ukleinek@informatik.uni-freiburg.de>
Caused-By       : Avi Kivity <avi@qumranet.com>
                  commit a52b1752c077cb919b71167c54968a0b91673281
Handled-By      : ?
Status          : unknown

Subject         : Section mismatch: reference to .init.data:cpu_llc_id (between 'set_cpu_sibling_map' and 'initialize_secondary')
References      : http://lkml.org/lkml/2007/7/19/202
Last known good : ?
Submitter       : Gabriel C <nix.or.die@googlemail.com>
Caused-By       : Jeremy Fitzhardinge <jeremy@xensource.com>
                  commit c70df74376c1e29a04e07e23dd3f4c384d6166dd
Handled-By      : ?
Status          : unknown


Subject         : Oops while modprobing phy fixed module
References      : http://lkml.org/lkml/2007/7/14/63
Last known good : ?
Submitter       : Gabriel C <nix.or.die@googlemail.com>
Caused-By       : Tejun Heo <htejun@gmail.com>
                  commit 3007e997de91ec59af39a3f9c91595b31ae6e08b
Handled-By      : Satyam Sharma <satyam.sharma@gmail.com>
                  Tejun Heo <htejun@gmail.com>
Status          : unknown



Block layer

Subject         : broken {sd,hd}parm
References      : http://lkml.org/lkml/2007/7/16/389
Last known good : ?
Submitter       : Gabriel C <nix.or.die@googlemail.com>
Caused-By       : ?
Handled-By      : FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Status          : problem is being debugged



DRM

Subject         : wine locks up system
References      : http://lkml.org/lkml/2007/7/17/128
Last known good : ?
Submitter       : Charles Gagalac <charles.gagalac@gmail.com>
Caused-By       : commit d4e2cbe9cb9219fc924191a6baa2369140cb5ea8
                  Dave Airlie <airlied@linux.ie>
                  Michel Dänzer <michel@tungstengraphics.com>
                  Kristian Høgsberg <krh@redhat.com>
Handled-By      : 
Status          : unknown



Regards,
Michal

--
LOG
http://www.stardust.webpages.pl/log/
