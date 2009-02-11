Return-Path: <linux-kernel-owner+w=401wt.eu-S1755417AbZBKHQx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417AbZBKHQx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 02:16:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751600AbZBKHQo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 02:16:44 -0500
Received: from fk-out-0910.google.com ([209.85.128.191]:50370 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510AbZBKHQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 02:16:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:mail-followup-to
         :references:mime-version:content-type:content-disposition
         :in-reply-to:user-agent;
        b=riofAtJcV/vLLdG23RSWUYri/jl55WM+jbDbjidJz58EaCtYp0DTiPUTWDVrdIfXAO
         zaDLoL/kNlmkw3FfWTD7k1Ll3+SQDul0q/p7NgQswWVPWC0CVL7GRHXdWmvktw0ZJ+6v
         YxE5MAPEQh/oeCyWpQloOrqBU4zYLgdqAGwsA=
Date: Wed, 11 Feb 2009 08:16:40 +0100
From: Borislav Petkov <petkovbb@googlemail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] ide: more unifications of ATA and ATAPI support
Message-ID: <20090211071640.GD937@gollum.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20090209231945.32406.14874.sendpatchset@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20090209231945.32406.14874.sendpatchset@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 10, 2009 at 12:19:45AM +0100, Bartlomiej Zolnierkiewicz wrote:
> 
> After this patchset we have a valid struct ide_cmd available also for
> ATA_CMD_PACKET commands and comparing struct ide_atapi_pc with ide_cmd it
> seems that there are many similarities between them and that we may just
> merge both structs (this should also allow us to unify ide-cd code with
> non-ide-cd one in ide-atapi.c later).  From the quick look the only gotcha
> is REQUEST SENSE handling, ->request_sense_pc needs to be converted to
> ->request_sense_cmd and we have to be careful with choosing right 'cmd'
> in *_issue_pc()...
> 
> Borislav, please take a look and tell me what do you think about it
> (also feel free to go ahead with patches :-)...

Yep, like it, especially the idea of a unified ide_cmd thingy and
removing the atapi_pc :).

ACK.

-- 
Regards/Gruss,
    Boris.
