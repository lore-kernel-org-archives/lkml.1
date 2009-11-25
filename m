Return-Path: <linux-kernel-owner+w=401wt.eu-S1758745AbZKYLo2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758745AbZKYLo2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 06:44:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758641AbZKYLo1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 06:44:27 -0500
Received: from ns.firmix.at ([62.141.48.66]:1024 "EHLO ns.firmix.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758621AbZKYLo0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 06:44:26 -0500
Subject: Re: cannot compile linux-2.6-tip tree
From: Bernd Petrovitsch <bernd@firmix.at>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, rostedt@goodmis.org, fweisbec@gmail.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <20091125090018.GD1940@jolsa.lab.eng.brq.redhat.com>
References: <20091124124107.GA1975@jolsa.lab.eng.brq.redhat.com>
	 <20091124154511.GG21821@elte.hu>
	 <20091124172208.GG1975@jolsa.lab.eng.brq.redhat.com>
	 <1259101632.6188.6.camel@gimli.petrovitsch.priv.at>
	 <20091125090018.GD1940@jolsa.lab.eng.brq.redhat.com>
Content-Type: text/plain
Organization: Firmix Software GmbH
Date: Wed, 25 Nov 2009 12:44:26 +0100
Message-Id: <1259149466.11337.112.camel@tara.firmix.at>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
X-Firmix-Scanned-By: MIMEDefang 2.67 on ns.firmix.at
X-Firmix-Spam-Score: -2.286 () AWL,BAYES_00,FORGED_RCVD_HELO,SPF_HELO_PASS,SPF_PASS
X-Firmix-Spam-Status: No, hits=-2.286 required=5
X-Firmix-Envelope-From: <bernd@firmix.at>
X-Firmix-Envelope-To: <linux-kernel@vger.kernel.org>
X-Firmix-Received-Date: Wed, 25 Nov 2009 12:44:32 CET
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-11-25 at 10:00 +0100, Jiri Olsa wrote:
> On Tue, Nov 24, 2009 at 11:27:12PM +0100, Bernd Petrovitsch wrote:
[...]
> > Save .config, `make mrproper`, put .config back, `make` and see it it
> > persists.
> I did "git clean -xdf" to wipe all out and hit the same issue
Just to be curious: What is that equivalent to `make mrproper`?
Doing (on x86_64, current mainline-tip or so)
----  snip  ----
{2}make -C git-vanilla mrproper
[...]
{3}make -C git-vanilla allmodconfig
[...]
{4}make -C git-vanilla
[...]
{5}cp -a git-vanilla git-vanilla-2
{6}make -C git-vanilla mrproper
[...]
{7}(cd git-vanilla-2 && git clean -xdf)
[...]
{8}diff -qr git-vanilla git-vanilla-2
Only in git-vanilla/drivers/gpu/drm/radeon: r100_reg_safe.h
Only in git-vanilla/drivers/gpu/drm/radeon: r200_reg_safe.h
Only in git-vanilla/drivers/gpu/drm/radeon: r300_reg_safe.h
Only in git-vanilla/drivers/gpu/drm/radeon: rn50_reg_safe.h
Only in git-vanilla/drivers/gpu/drm/radeon: rs600_reg_safe.h
Only in git-vanilla/drivers/gpu/drm/radeon: rv515_reg_safe.h
Only in git-vanilla/include: asm-x86
----  snip  ----
I don't know if that could make a significant difference.

	Bernd
-- 
Firmix Software GmbH                   http://www.firmix.at/
mobil: +43 664 4416156                 fax: +43 1 7890849-55
          Embedded Linux Development and Services


