Return-Path: <linux-kernel-owner+w=401wt.eu-S932492Ab0AFRoA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932492Ab0AFRoA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 12:44:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932410Ab0AFRn7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 12:43:59 -0500
Received: from mail-iw0-f194.google.com ([209.85.223.194]:36628 "EHLO
	mail-iw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932283Ab0AFRn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 12:43:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=E+4kVpRcJyQKW3G8u/N8gYlTgNVeXrQjGRH8Pygur8eD+SgNUBG3R2QKh4OjQuB0/1
         3cDXsNBjXkWrV2WRQ6y7dYBC9zI6LIfRMcJkYtM4gS7tcSR6z6QIqKgjB0eFN9f5m86p
         ddt4226PxDoy0O3Hq8WG9V6TYELMqXeiBI8og=
MIME-Version: 1.0
In-Reply-To: <1262795743-15009-2-git-send-email-jslaby@suse.cz>
References: <1262795743-15009-1-git-send-email-jslaby@suse.cz> 
	<1262795743-15009-2-git-send-email-jslaby@suse.cz>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 6 Jan 2010 09:43:38 -0800
Message-ID: <43e72e891001060943j25d68f2dhd3f6d2877b5c460f@mail.gmail.com>
Subject: Re: [PATCH 2/2] NET: wireless, fix memory leak
To: Jiri Slaby <jslaby@suse.cz>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 6, 2010 at 8:35 AM, Jiri Slaby <jslaby@suse.cz> wrote:
> Stanse found a memory leak in cfg80211_wext_siwscan. creq is not
> freed/assigned on all paths. Fix that.

CC stable?

 Luis
