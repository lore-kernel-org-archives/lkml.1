Return-Path: <linux-kernel-owner+w=401wt.eu-S1752349AbZIQOQ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752349AbZIQOQ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 10:16:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751805AbZIQOQz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 10:16:55 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:64570 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbZIQOQy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 10:16:54 -0400
MIME-Version: 1.0
In-Reply-To: <4AB1A8FD.2010805@gmail.com>
References: <cover.1251388414.git.mst@redhat.com> <4AAFF437.7060100@gmail.com>
	 <4AB0A070.1050400@redhat.com> <4AB0CFA5.6040104@gmail.com>
	 <4AB0E2A2.3080409@redhat.com> <4AB0F1EF.5050102@gmail.com>
	 <4AB10B67.2050108@redhat.com> <4AB13B09.5040308@gmail.com>
	 <4AB151D7.10402@redhat.com> <4AB1A8FD.2010805@gmail.com>
Date: Thu, 17 Sep 2009 09:16:56 -0500
Message-ID: <90eb1dc70909170716i5de0b909tf69c93e679f5fbc8@mail.gmail.com>
Subject: Re: [PATCHv5 3/3] vhost_net: a kernel-level virtio server
From: Javier Guerra <javier@guerrag.com>
To: Gregory Haskins <gregory.haskins@gmail.com>
Cc: Avi Kivity <avi@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>,
       "Ira W. Snyder" <iws@ovro.caltech.edu>, netdev@vger.kernel.org,
       virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, mingo@elte.hu, linux-mm@kvack.org,
       akpm@linux-foundation.org, hpa@zytor.com,
       Rusty Russell <rusty@rustcorp.com.au>, s.hetze@linux-ag.com,
       alacrityvm-devel@lists.sourceforge.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 16, 2009 at 10:11 PM, Gregory Haskins
<gregory.haskins@gmail.com> wrote:
> It is certainly not a requirement to make said
> chip somehow work with existing drivers/facilities on bare metal, per
> se.  Why should virtual systems be different?

i'd guess it's an issue of support resources.  a hardware developer
creates a chip and immediately sells it, getting small but assured
revenue, with it they write (or pays to write) drivers for a couple of
releases, and stop to manufacture it as soon as it's not profitable.

software has a much longer lifetime, especially at the platform-level
(and KVM is a platform for a lot of us). also, being GPL, it's cheaper
to produce but has (much!) more limited resources.  creating a new
support issue is a scary thought.


-- 
Javier
