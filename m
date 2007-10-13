Return-Path: <linux-kernel-owner+w=401wt.eu-S1760558AbXJMAJR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760558AbXJMAJR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 20:09:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753127AbXJMAJA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 20:09:00 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:53036 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751983AbXJMAI4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 20:08:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=aF3+G7WHYTV+QpuU8X9/IA+iYlYpkkJDUJjWW64cHr7ZHOho9HfI1ewv/l2J3xNoSueXE8ieVAJNEiJ2bzxNa0jCtnnz77bjNBtRkxzOf4HFU3azwllqZXTWIz06tOQlQGuaNplJGXisiQ+wC6R9NZL/raTYjkiYSxYszDBJKc0=
Date: Sat, 13 Oct 2007 02:08:40 +0200
From: Alejandro Riveira =?UTF-8?B?RmVybsOhbmRleg==?= 
	<ariveira@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Build error in block/compat_ioctl.c latest git
Message-ID: <20071013020840.1cf1261a@gmail.com>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  Latest commit is
  ab9c232286c2b77be78441c2d8396500b045777e

 /home/alex/kernel/linux-2.6/block/compat_ioctl.c: En la función ‘compat_put_ushort’:
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:16: error: declaración implícita de la función ‘compat_ptr’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c: En la función ‘compat_put_int’:
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:21: error: ‘compat_int_t’ no se declaró aquí (primer uso en esta función)
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:21: error: (Cada identificador no declarado solamente se reporta una vez
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:21: error: ara cada funcion en la que aparece.)
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:21: error: expected expression before ‘)’ token
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:21: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘__pu_val’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:21: error: expected expression before ‘)’ token
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:21: error: expected expression before ‘)’ token
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:21: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:21: error: expected expression before ‘)’ token
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:21: error: expected expression before ‘)’ token
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:21: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:21: error: expected expression before ‘)’ token
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:21: error: expected expression before ‘)’ token
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:21: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:21: error: expected expression before ‘)’ token
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:21: error: expected expression before ‘)’ token
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:21: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:21: error: expected expression before ‘)’ token
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:21: error: expected expression before ‘)’ token
/home/alex/kernel/linux-2.6/block/compat_ioctl.c: En la función ‘compat_put_long’:
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:26: error: ‘compat_long_t’ no se declaró aquí (primer uso en esta función)
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:26: error: expected expression before ‘)’ token
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:26: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘__pu_val’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:26: error: expected expression before ‘)’ token
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:26: error: expected expression before ‘)’ token
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:26: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:26: error: expected expression before ‘)’ token
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:26: error: expected expression before ‘)’ token
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:26: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:26: error: expected expression before ‘)’ token
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:26: error: expected expression before ‘)’ token
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:26: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:26: error: expected expression before ‘)’ token
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:26: error: expected expression before ‘)’ token
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:26: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:26: error: expected expression before ‘)’ token
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:26: error: expected expression before ‘)’ token
/home/alex/kernel/linux-2.6/block/compat_ioctl.c: En el nivel principal:
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:29: error: expected declaration specifiers or ‘...’ before ‘compat_ulong_t’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c: En la función ‘compat_put_ulong’:
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:31: error: ‘compat_ulong_t’ no se declaró aquí (primer uso en esta función)
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:31: error: expected expression before ‘)’ token
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:31: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘__pu_val’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:31: error: ‘val’ no se declaró aquí (primer uso en esta función)
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:31: error: expected expression before ‘)’ token
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:31: error: expected expression before ‘)’ token
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:31: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:31: error: expected expression before ‘)’ token
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:31: error: expected expression before ‘)’ token
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:31: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:31: error: expected expression before ‘)’ token
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:31: error: expected expression before ‘)’ token
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:31: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:31: error: expected expression before ‘)’ token
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:31: error: expected expression before ‘)’ token
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:31: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:31: error: expected expression before ‘)’ token
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:31: error: expected expression before ‘)’ token
/home/alex/kernel/linux-2.6/block/compat_ioctl.c: En la función ‘compat_put_u64’:
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:36: error: ‘compat_u64’ no se declaró aquí (primer uso en esta función)
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:36: error: expected expression before ‘)’ token
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:36: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘__pu_val’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:36: error: expected expression before ‘)’ token
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:36: error: expected expression before ‘)’ token
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:36: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:36: error: expected expression before ‘)’ token
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:36: error: expected expression before ‘)’ token
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:36: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:36: error: expected expression before ‘)’ token
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:36: error: expected expression before ‘)’ token
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:36: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:36: error: expected expression before ‘)’ token
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:36: error: expected expression before ‘)’ token
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:36: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:36: error: expected expression before ‘)’ token
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:36: error: expected expression before ‘)’ token
/home/alex/kernel/linux-2.6/block/compat_ioctl.c: En la función ‘compat_hdio_ioctl’:
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:88: aviso: la asignación crea un puntero desde un entero sin una conversión
/home/alex/kernel/linux-2.6/block/compat_ioctl.c: En el nivel principal:
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:98: error: expected specifier-qualifier-list before ‘compat_int_t’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:104: error: expected specifier-qualifier-list before ‘compat_caddr_t’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c: En la función ‘compat_cdrom_read_audio’:
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:122: error: declaración implícita de la función ‘compat_alloc_user_space’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:122: aviso: la asignación crea un puntero desde un entero sin una conversión
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:123: aviso: la asignación crea un puntero desde un entero sin una conversión
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:125: error: declaración implícita de la función ‘copy_in_user’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:128: error: ‘compat_caddr_t’ no se declaró aquí (primer uso en esta función)
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:131: error: ‘struct compat_cdrom_read_audio’ no tiene un miembro llamado ‘buf’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:131: error: ‘struct compat_cdrom_read_audio’ no tiene un miembro llamado ‘buf’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:131: error: ‘struct compat_cdrom_read_audio’ no tiene un miembro llamado ‘buf’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:131: error: ‘struct compat_cdrom_read_audio’ no tiene un miembro llamado ‘buf’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:131: error: ‘struct compat_cdrom_read_audio’ no tiene un miembro llamado ‘buf’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:131: error: ‘struct compat_cdrom_read_audio’ no tiene un miembro llamado ‘buf’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:131: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:133: aviso: la asignación crea un puntero desde un entero sin una conversión
/home/alex/kernel/linux-2.6/block/compat_ioctl.c: En la función ‘compat_cdrom_generic_command’:
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:150: aviso: la asignación crea un puntero desde un entero sin una conversión
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:151: aviso: la asignación crea un puntero desde un entero sin una conversión
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:154: error: ‘struct compat_cdrom_generic_command’ no tiene un miembro llamado ‘buffer’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:154: error: ‘struct compat_cdrom_generic_command’ no tiene un miembro llamado ‘buffer’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:154: error: ‘struct compat_cdrom_generic_command’ no tiene un miembro llamado ‘buffer’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:154: error: ‘struct compat_cdrom_generic_command’ no tiene un miembro llamado ‘buffer’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:154: error: ‘struct compat_cdrom_generic_command’ no tiene un miembro llamado ‘buffer’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:154: error: ‘struct compat_cdrom_generic_command’ no tiene un miembro llamado ‘buffer’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:154: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:155: aviso: la asignación crea un puntero desde un entero sin una conversión
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:156: error: ‘struct compat_cdrom_generic_command’ no tiene un miembro llamado ‘buflen’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:158: error: ‘struct compat_cdrom_generic_command’ no tiene un miembro llamado ‘sense’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:158: error: ‘struct compat_cdrom_generic_command’ no tiene un miembro llamado ‘sense’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:158: error: ‘struct compat_cdrom_generic_command’ no tiene un miembro llamado ‘sense’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:158: error: ‘struct compat_cdrom_generic_command’ no tiene un miembro llamado ‘sense’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:158: error: ‘struct compat_cdrom_generic_command’ no tiene un miembro llamado ‘sense’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:158: error: ‘struct compat_cdrom_generic_command’ no tiene un miembro llamado ‘sense’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:158: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:159: aviso: la asignación crea un puntero desde un entero sin una conversión
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:160: error: ‘struct compat_cdrom_generic_command’ no tiene un miembro llamado ‘data_direction’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:160: error: ‘struct compat_cdrom_generic_command’ no tiene un miembro llamado ‘data_direction’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:160: error: ‘struct compat_cdrom_generic_command’ no tiene un miembro llamado ‘data_direction’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:160: error: ‘struct compat_cdrom_generic_command’ no tiene un miembro llamado ‘data_direction’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:160: error: ‘struct compat_cdrom_generic_command’ no tiene un miembro llamado ‘data_direction’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:160: error: ‘struct compat_cdrom_generic_command’ no tiene un miembro llamado ‘data_direction’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:160: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:162: error: ‘struct compat_cdrom_generic_command’ no tiene un miembro llamado ‘quiet’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:162: error: ‘struct compat_cdrom_generic_command’ no tiene un miembro llamado ‘quiet’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:162: error: ‘struct compat_cdrom_generic_command’ no tiene un miembro llamado ‘quiet’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:162: error: ‘struct compat_cdrom_generic_command’ no tiene un miembro llamado ‘quiet’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:162: error: ‘struct compat_cdrom_generic_command’ no tiene un miembro llamado ‘quiet’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:162: error: ‘struct compat_cdrom_generic_command’ no tiene un miembro llamado ‘quiet’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:162: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:164: error: ‘struct compat_cdrom_generic_command’ no tiene un miembro llamado ‘timeout’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:164: error: ‘struct compat_cdrom_generic_command’ no tiene un miembro llamado ‘timeout’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:164: error: ‘struct compat_cdrom_generic_command’ no tiene un miembro llamado ‘timeout’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:164: error: ‘struct compat_cdrom_generic_command’ no tiene un miembro llamado ‘timeout’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:164: error: ‘struct compat_cdrom_generic_command’ no tiene un miembro llamado ‘timeout’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:164: error: ‘struct compat_cdrom_generic_command’ no tiene un miembro llamado ‘timeout’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:164: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:166: error: ‘struct compat_cdrom_generic_command’ no tiene un miembro llamado ‘reserved’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:166: error: ‘struct compat_cdrom_generic_command’ no tiene un miembro llamado ‘reserved’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:166: error: ‘struct compat_cdrom_generic_command’ no tiene un miembro llamado ‘reserved’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:166: error: ‘struct compat_cdrom_generic_command’ no tiene un miembro llamado ‘reserved’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:166: error: ‘struct compat_cdrom_generic_command’ no tiene un miembro llamado ‘reserved’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:166: error: ‘struct compat_cdrom_generic_command’ no tiene un miembro llamado ‘reserved’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:166: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:167: aviso: la asignación crea un puntero desde un entero sin una conversión
/home/alex/kernel/linux-2.6/block/compat_ioctl.c: En el nivel principal:
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:174: error: expected specifier-qualifier-list before ‘compat_int_t’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c: En la función ‘compat_blkpg_ioctl’:
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:183: aviso: la inicialización crea un puntero desde un entero sin una conversión
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:184: error: ‘compat_caddr_t’ no se declaró aquí (primer uso en esta función)
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:184: error: expected ‘;’ before ‘udata’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:185: error: ‘compat_int_t’ no se declaró aquí (primer uso en esta función)
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:185: error: expected ‘;’ before ‘n’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:186: aviso: ISO C90 prohíbe las declaraciones mezcladas y código
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:188: error: ‘struct compat_blkpg_ioctl_arg’ no tiene un miembro llamado ‘op’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:188: error: ‘struct compat_blkpg_ioctl_arg’ no tiene un miembro llamado ‘op’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:188: error: ‘struct compat_blkpg_ioctl_arg’ no tiene un miembro llamado ‘op’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:188: error: ‘struct compat_blkpg_ioctl_arg’ no tiene un miembro llamado ‘op’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:188: error: ‘struct compat_blkpg_ioctl_arg’ no tiene un miembro llamado ‘op’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:188: error: ‘n’ no se declaró aquí (primer uso en esta función)
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:188: error: ‘struct compat_blkpg_ioctl_arg’ no tiene un miembro llamado ‘op’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:188: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:190: error: ‘struct compat_blkpg_ioctl_arg’ no tiene un miembro llamado ‘flags’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:190: error: ‘struct compat_blkpg_ioctl_arg’ no tiene un miembro llamado ‘flags’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:190: error: ‘struct compat_blkpg_ioctl_arg’ no tiene un miembro llamado ‘flags’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:190: error: ‘struct compat_blkpg_ioctl_arg’ no tiene un miembro llamado ‘flags’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:190: error: ‘struct compat_blkpg_ioctl_arg’ no tiene un miembro llamado ‘flags’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:190: error: ‘struct compat_blkpg_ioctl_arg’ no tiene un miembro llamado ‘flags’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:190: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:192: error: ‘struct compat_blkpg_ioctl_arg’ no tiene un miembro llamado ‘datalen’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:192: error: ‘struct compat_blkpg_ioctl_arg’ no tiene un miembro llamado ‘datalen’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:192: error: ‘struct compat_blkpg_ioctl_arg’ no tiene un miembro llamado ‘datalen’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:192: error: ‘struct compat_blkpg_ioctl_arg’ no tiene un miembro llamado ‘datalen’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:192: error: ‘struct compat_blkpg_ioctl_arg’ no tiene un miembro llamado ‘datalen’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:192: error: ‘struct compat_blkpg_ioctl_arg’ no tiene un miembro llamado ‘datalen’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:192: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:194: error: ‘struct compat_blkpg_ioctl_arg’ no tiene un miembro llamado ‘data’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:194: error: ‘struct compat_blkpg_ioctl_arg’ no tiene un miembro llamado ‘data’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:194: error: ‘struct compat_blkpg_ioctl_arg’ no tiene un miembro llamado ‘data’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:194: error: ‘struct compat_blkpg_ioctl_arg’ no tiene un miembro llamado ‘data’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:194: error: ‘struct compat_blkpg_ioctl_arg’ no tiene un miembro llamado ‘data’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:194: error: ‘udata’ no se declaró aquí (primer uso en esta función)
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:194: error: ‘struct compat_blkpg_ioctl_arg’ no tiene un miembro llamado ‘data’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:194: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:195: aviso: la asignación crea un puntero desde un entero sin una conversión
/home/alex/kernel/linux-2.6/block/compat_ioctl.c: En el nivel principal:
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:207: error: expected specifier-qualifier-list before ‘compat_uint_t’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:221: error: expected specifier-qualifier-list before ‘compat_ulong_t’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:243: error: expected specifier-qualifier-list before ‘compat_ulong_t’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:260: error: expected specifier-qualifier-list before ‘compat_int_t’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:277: error: expected specifier-qualifier-list before ‘compat_ulong_t’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c: En la función ‘compat_fd_ioctl’:
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:332: error: ‘compat_uptr_t’ no se declaró aquí (primer uso en esta función)
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:332: error: expected ‘;’ before ‘name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:333: aviso: ISO C90 prohíbe las declaraciones mezcladas y código
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:336: aviso: la asignación crea un puntero desde un entero sin una conversión
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:342: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘size’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:342: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘size’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:342: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘size’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:342: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘size’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:342: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘size’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:342: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:343: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘sect’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:343: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘sect’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:343: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘sect’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:343: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘sect’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:343: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘sect’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:343: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:344: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘head’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:344: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘head’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:344: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘head’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:344: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘head’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:344: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘head’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:344: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:345: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘track’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:345: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘track’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:345: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘track’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:345: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘track’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:345: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘track’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:345: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:346: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘stretch’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:346: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘stretch’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:346: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘stretch’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:346: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘stretch’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:346: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘stretch’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:346: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:347: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘gap’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:347: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘gap’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:347: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘gap’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:347: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘gap’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:347: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘gap’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:347: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:348: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘rate’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:348: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘rate’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:348: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘rate’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:348: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘rate’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:348: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘rate’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:348: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:349: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘spec1’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:349: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘spec1’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:349: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘spec1’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:349: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘spec1’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:349: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘spec1’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:349: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:350: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘fmt_gap’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:350: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘fmt_gap’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:350: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘fmt_gap’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:350: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘fmt_gap’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:350: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘fmt_gap’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:350: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:351: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:351: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:351: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:351: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:351: error: ‘name’ no se declaró aquí (primer uso en esta función)
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:351: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:351: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:352: aviso: la asignación crea un puntero desde un entero sin una conversión
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:365: aviso: la asignación crea un puntero desde un entero sin una conversión
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:372: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘max_dtr’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:372: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘max_dtr’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:372: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘max_dtr’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:372: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘max_dtr’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:372: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘max_dtr’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:372: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:373: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘hlt’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:373: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘hlt’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:373: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘hlt’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:373: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘hlt’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:373: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘hlt’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:373: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:374: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘hut’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:374: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘hut’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:374: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘hut’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:374: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘hut’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:374: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘hut’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:374: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:375: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘srt’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:375: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘srt’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:375: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘srt’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:375: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘srt’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:375: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘srt’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:375: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:376: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘spinup’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:376: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘spinup’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:376: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘spinup’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:376: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘spinup’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:376: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘spinup’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:376: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:377: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘spindown’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:377: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘spindown’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:377: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘spindown’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:377: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘spindown’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:377: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘spindown’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:377: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:378: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘spindown_offset’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:378: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘spindown_offset’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:378: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘spindown_offset’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:378: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘spindown_offset’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:378: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘spindown_offset’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:378: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:379: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘select_delay’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:379: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘select_delay’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:379: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘select_delay’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:379: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘select_delay’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:379: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘select_delay’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:379: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:380: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘rps’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:380: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘rps’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:380: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘rps’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:380: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘rps’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:380: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘rps’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:380: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:381: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘tracks’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:381: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘tracks’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:381: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘tracks’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:381: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘tracks’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:381: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘tracks’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:381: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:382: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘timeout’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:382: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘timeout’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:382: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘timeout’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:382: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘timeout’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:382: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘timeout’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:382: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:383: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘interleave_sect’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:383: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘interleave_sect’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:383: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘interleave_sect’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:383: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘interleave_sect’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:383: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘interleave_sect’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:383: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:384: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘max_errors’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:385: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘flags’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:385: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘flags’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:385: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘flags’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:385: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘flags’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:385: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘flags’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:385: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:386: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘read_track’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:386: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘read_track’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:386: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘read_track’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:386: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘read_track’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:386: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘read_track’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:386: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:387: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘autodetect’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:388: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘checkfreq’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:388: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘checkfreq’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:388: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘checkfreq’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:388: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘checkfreq’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:388: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘checkfreq’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:388: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:389: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘native_format’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:389: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘native_format’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:389: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘native_format’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:389: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘native_format’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:389: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘native_format’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:389: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:424: aviso: la inicialización crea un puntero desde un entero sin una conversión
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:426: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘size’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:426: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘size’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:426: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:426: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘size’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:426: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘size’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:426: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:426: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘size’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:426: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘size’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:426: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:426: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘size’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:426: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘size’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:426: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘size’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:426: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:426: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:426: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘size’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:427: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘sect’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:427: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘sect’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:427: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:427: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘sect’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:427: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘sect’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:427: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:427: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘sect’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:427: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘sect’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:427: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:427: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘sect’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:427: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘sect’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:427: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘sect’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:427: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:427: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:427: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘sect’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:428: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘head’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:428: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘head’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:428: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:428: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘head’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:428: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘head’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:428: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:428: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘head’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:428: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘head’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:428: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:428: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘head’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:428: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘head’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:428: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘head’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:428: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:428: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:428: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘head’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:429: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘track’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:429: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘track’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:429: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:429: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘track’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:429: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘track’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:429: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:429: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘track’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:429: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘track’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:429: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:429: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘track’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:429: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘track’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:429: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘track’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:429: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:429: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:429: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘track’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:430: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘stretch’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:430: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘stretch’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:430: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:430: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘stretch’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:430: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘stretch’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:430: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:430: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘stretch’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:430: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘stretch’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:430: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:430: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘stretch’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:430: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘stretch’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:430: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘stretch’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:430: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:430: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:430: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘stretch’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:431: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘gap’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:431: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘gap’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:431: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:431: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘gap’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:431: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘gap’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:431: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:431: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘gap’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:431: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘gap’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:431: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:431: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘gap’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:431: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘gap’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:431: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘gap’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:431: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:431: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:431: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘gap’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:432: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘rate’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:432: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘rate’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:432: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:432: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘rate’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:432: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘rate’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:432: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:432: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘rate’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:432: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘rate’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:432: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:432: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘rate’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:432: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘rate’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:432: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘rate’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:432: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:432: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:432: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘rate’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:433: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘spec1’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:433: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘spec1’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:433: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:433: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘spec1’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:433: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘spec1’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:433: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:433: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘spec1’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:433: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘spec1’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:433: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:433: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘spec1’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:433: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘spec1’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:433: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘spec1’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:433: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:433: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:433: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘spec1’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:434: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘fmt_gap’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:434: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘fmt_gap’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:434: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:434: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘fmt_gap’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:434: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘fmt_gap’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:434: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:434: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘fmt_gap’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:434: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘fmt_gap’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:434: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:434: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘fmt_gap’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:434: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘fmt_gap’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:434: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘fmt_gap’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:434: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:434: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:434: error: ‘struct compat_floppy_struct’ no tiene un miembro llamado ‘fmt_gap’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:435: error: ‘compat_caddr_t’ no se declaró aquí (primer uso en esta función)
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:435: error: expected expression before ‘)’ token
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:435: error: expected expression before ‘)’ token
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:435: aviso: conversión de puntero a entero de tamaño diferente
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:435: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:435: error: expected expression before ‘)’ token
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:435: error: expected expression before ‘)’ token
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:435: aviso: conversión de puntero a entero de tamaño diferente
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:435: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:435: error: expected expression before ‘)’ token
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:435: error: expected expression before ‘)’ token
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:435: aviso: conversión de puntero a entero de tamaño diferente
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:435: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:435: error: expected expression before ‘)’ token
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:435: error: expected expression before ‘)’ token
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:435: error: expected expression before ‘)’ token
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:435: aviso: conversión de puntero a entero de tamaño diferente
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:435: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:435: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:435: error: expected expression before ‘)’ token
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:443: aviso: la asignación crea un puntero desde un entero sin una conversión
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:445: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘max_dtr’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:445: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘max_dtr’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:445: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:445: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘max_dtr’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:445: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘max_dtr’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:445: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:445: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘max_dtr’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:445: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘max_dtr’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:445: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:445: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘max_dtr’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:445: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘max_dtr’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:445: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘max_dtr’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:445: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:445: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:445: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘max_dtr’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:446: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘hlt’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:446: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘hlt’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:446: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:446: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘hlt’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:446: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘hlt’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:446: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:446: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘hlt’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:446: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘hlt’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:446: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:446: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘hlt’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:446: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘hlt’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:446: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘hlt’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:446: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:446: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:446: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘hlt’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:447: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘hut’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:447: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘hut’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:447: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:447: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘hut’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:447: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘hut’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:447: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:447: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘hut’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:447: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘hut’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:447: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:447: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘hut’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:447: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘hut’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:447: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘hut’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:447: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:447: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:447: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘hut’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:448: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘srt’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:448: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘srt’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:448: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:448: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘srt’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:448: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘srt’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:448: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:448: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘srt’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:448: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘srt’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:448: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:448: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘srt’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:448: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘srt’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:448: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘srt’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:448: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:448: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:448: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘srt’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:449: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘spinup’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:449: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘spinup’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:449: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:449: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘spinup’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:449: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘spinup’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:449: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:449: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘spinup’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:449: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘spinup’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:449: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:449: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘spinup’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:449: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘spinup’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:449: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘spinup’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:449: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:449: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:449: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘spinup’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:450: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘spindown’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:450: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘spindown’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:450: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:450: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘spindown’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:450: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘spindown’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:450: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:450: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘spindown’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:450: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘spindown’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:450: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:450: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘spindown’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:450: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘spindown’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:450: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘spindown’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:450: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:450: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:450: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘spindown’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:451: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘spindown_offset’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:451: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘spindown_offset’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:451: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:451: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘spindown_offset’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:451: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘spindown_offset’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:451: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:451: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘spindown_offset’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:451: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘spindown_offset’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:451: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:451: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘spindown_offset’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:451: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘spindown_offset’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:451: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘spindown_offset’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:451: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:451: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:451: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘spindown_offset’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:452: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘select_delay’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:452: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘select_delay’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:452: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:452: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘select_delay’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:452: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘select_delay’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:452: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:452: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘select_delay’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:452: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘select_delay’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:452: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:452: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘select_delay’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:452: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘select_delay’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:452: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘select_delay’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:452: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:452: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:452: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘select_delay’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:453: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘rps’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:453: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘rps’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:453: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:453: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘rps’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:453: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘rps’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:453: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:453: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘rps’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:453: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘rps’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:453: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:453: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘rps’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:453: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘rps’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:453: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘rps’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:453: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:453: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:453: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘rps’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:454: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘tracks’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:454: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘tracks’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:454: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:454: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘tracks’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:454: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘tracks’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:454: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:454: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘tracks’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:454: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘tracks’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:454: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:454: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘tracks’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:454: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘tracks’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:454: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘tracks’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:454: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:454: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:454: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘tracks’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:455: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘timeout’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:455: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘timeout’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:455: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:455: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘timeout’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:455: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘timeout’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:455: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:455: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘timeout’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:455: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘timeout’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:455: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:455: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘timeout’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:455: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘timeout’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:455: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘timeout’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:455: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:455: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:455: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘timeout’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:456: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘interleave_sect’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:456: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘interleave_sect’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:456: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:456: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘interleave_sect’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:456: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘interleave_sect’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:456: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:456: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘interleave_sect’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:456: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘interleave_sect’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:456: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:456: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘interleave_sect’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:456: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘interleave_sect’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:456: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘interleave_sect’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:456: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:456: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:456: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘interleave_sect’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:457: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘max_errors’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:458: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘flags’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:458: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘flags’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:458: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:458: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘flags’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:458: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘flags’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:458: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:458: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘flags’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:458: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘flags’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:458: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:458: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘flags’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:458: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘flags’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:458: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘flags’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:458: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:458: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:458: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘flags’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:459: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘read_track’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:459: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘read_track’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:459: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:459: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘read_track’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:459: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘read_track’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:459: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:459: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘read_track’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:459: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘read_track’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:459: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:459: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘read_track’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:459: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘read_track’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:459: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘read_track’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:459: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:459: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:459: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘read_track’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:460: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘autodetect’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:461: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘checkfreq’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:461: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘checkfreq’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:461: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:461: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘checkfreq’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:461: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘checkfreq’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:461: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:461: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘checkfreq’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:461: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘checkfreq’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:461: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:461: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘checkfreq’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:461: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘checkfreq’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:461: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘checkfreq’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:461: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:461: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:461: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘checkfreq’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:462: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘native_format’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:462: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘native_format’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:462: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:462: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘native_format’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:462: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘native_format’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:462: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:462: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘native_format’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:462: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘native_format’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:462: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:462: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘native_format’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:462: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘native_format’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:462: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘native_format’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:462: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:462: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:462: error: ‘struct compat_floppy_drive_params’ no tiene un miembro llamado ‘native_format’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:471: aviso: la asignación crea un puntero desde un entero sin una conversión
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:473: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘spinup_date’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:473: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘spinup_date’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:473: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:473: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘spinup_date’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:473: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘spinup_date’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:473: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:473: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘spinup_date’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:473: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘spinup_date’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:473: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:473: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘spinup_date’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:473: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘spinup_date’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:473: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘spinup_date’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:473: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:473: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:473: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘spinup_date’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:474: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘select_date’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:474: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘select_date’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:474: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:474: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘select_date’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:474: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘select_date’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:474: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:474: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘select_date’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:474: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘select_date’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:474: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:474: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘select_date’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:474: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘select_date’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:474: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘select_date’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:474: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:474: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:474: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘select_date’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:475: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘first_read_date’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:475: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘first_read_date’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:475: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:475: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘first_read_date’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:475: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘first_read_date’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:475: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:475: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘first_read_date’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:475: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘first_read_date’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:475: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:475: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘first_read_date’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:475: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘first_read_date’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:475: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘first_read_date’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:475: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:475: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:475: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘first_read_date’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:476: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘probed_format’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:476: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘probed_format’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:476: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:476: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘probed_format’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:476: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘probed_format’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:476: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:476: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘probed_format’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:476: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘probed_format’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:476: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:476: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘probed_format’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:476: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘probed_format’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:476: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘probed_format’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:476: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:476: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:476: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘probed_format’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:477: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘track’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:477: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘track’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:477: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:477: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘track’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:477: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘track’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:477: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:477: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘track’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:477: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘track’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:477: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:477: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘track’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:477: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘track’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:477: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘track’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:477: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:477: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:477: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘track’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:478: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘maxblock’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:478: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘maxblock’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:478: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:478: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘maxblock’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:478: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘maxblock’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:478: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:478: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘maxblock’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:478: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘maxblock’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:478: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:478: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘maxblock’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:478: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘maxblock’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:478: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘maxblock’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:478: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:478: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:478: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘maxblock’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:479: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘maxtrack’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:479: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘maxtrack’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:479: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:479: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘maxtrack’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:479: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘maxtrack’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:479: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:479: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘maxtrack’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:479: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘maxtrack’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:479: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:479: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘maxtrack’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:479: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘maxtrack’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:479: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘maxtrack’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:479: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:479: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:479: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘maxtrack’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:480: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘generation’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:480: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘generation’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:480: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:480: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘generation’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:480: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘generation’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:480: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:480: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘generation’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:480: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘generation’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:480: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:480: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘generation’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:480: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘generation’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:480: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘generation’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:480: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:480: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:480: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘generation’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:481: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘keep_data’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:481: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘keep_data’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:481: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:481: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘keep_data’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:481: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘keep_data’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:481: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:481: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘keep_data’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:481: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘keep_data’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:481: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:481: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘keep_data’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:481: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘keep_data’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:481: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘keep_data’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:481: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:481: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:481: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘keep_data’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:482: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘fd_ref’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:482: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘fd_ref’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:482: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:482: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘fd_ref’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:482: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘fd_ref’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:482: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:482: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘fd_ref’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:482: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘fd_ref’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:482: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:482: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘fd_ref’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:482: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘fd_ref’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:482: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘fd_ref’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:482: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:482: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:482: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘fd_ref’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:483: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘fd_device’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:483: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘fd_device’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:483: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:483: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘fd_device’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:483: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘fd_device’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:483: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:483: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘fd_device’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:483: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘fd_device’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:483: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:483: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘fd_device’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:483: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘fd_device’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:483: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘fd_device’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:483: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:483: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:483: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘fd_device’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:484: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘last_checked’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:484: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘last_checked’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:484: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:484: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘last_checked’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:484: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘last_checked’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:484: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:484: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘last_checked’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:484: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘last_checked’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:484: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:484: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘last_checked’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:484: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘last_checked’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:484: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘last_checked’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:484: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:484: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:484: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘last_checked’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:485: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘dmabuf’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:485: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘dmabuf’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:485: aviso: conversión de puntero a entero de tamaño diferente
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:485: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:485: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘dmabuf’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:485: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘dmabuf’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:485: aviso: conversión de puntero a entero de tamaño diferente
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:485: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:485: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘dmabuf’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:485: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘dmabuf’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:485: aviso: conversión de puntero a entero de tamaño diferente
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:485: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:485: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘dmabuf’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:485: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘dmabuf’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:485: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘dmabuf’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:485: aviso: conversión de puntero a entero de tamaño diferente
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:485: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:485: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:485: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘dmabuf’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:486: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘bufblocks’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:486: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘bufblocks’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:486: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:486: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘bufblocks’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:486: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘bufblocks’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:486: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:486: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘bufblocks’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:486: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘bufblocks’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:486: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:486: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘bufblocks’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:486: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘bufblocks’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:486: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘bufblocks’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:486: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:486: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:486: error: ‘struct compat_floppy_drive_struct’ no tiene un miembro llamado ‘bufblocks’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:494: aviso: la asignación crea un puntero desde un entero sin una conversión
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:495: error: ‘struct compat_floppy_fdc_state’ no tiene un miembro llamado ‘spec1’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:495: error: ‘struct compat_floppy_fdc_state’ no tiene un miembro llamado ‘spec1’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:495: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:495: error: ‘struct compat_floppy_fdc_state’ no tiene un miembro llamado ‘spec1’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:495: error: ‘struct compat_floppy_fdc_state’ no tiene un miembro llamado ‘spec1’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:495: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:495: error: ‘struct compat_floppy_fdc_state’ no tiene un miembro llamado ‘spec1’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:495: error: ‘struct compat_floppy_fdc_state’ no tiene un miembro llamado ‘spec1’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:495: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:495: error: ‘struct compat_floppy_fdc_state’ no tiene un miembro llamado ‘spec1’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:495: error: ‘struct compat_floppy_fdc_state’ no tiene un miembro llamado ‘spec1’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:495: error: ‘struct compat_floppy_fdc_state’ no tiene un miembro llamado ‘spec1’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:495: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:495: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:495: error: ‘struct compat_floppy_fdc_state’ no tiene un miembro llamado ‘spec1’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:496: error: ‘struct compat_floppy_fdc_state’ no tiene un miembro llamado ‘spec2’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:496: error: ‘struct compat_floppy_fdc_state’ no tiene un miembro llamado ‘spec2’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:496: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:496: error: ‘struct compat_floppy_fdc_state’ no tiene un miembro llamado ‘spec2’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:496: error: ‘struct compat_floppy_fdc_state’ no tiene un miembro llamado ‘spec2’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:496: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:496: error: ‘struct compat_floppy_fdc_state’ no tiene un miembro llamado ‘spec2’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:496: error: ‘struct compat_floppy_fdc_state’ no tiene un miembro llamado ‘spec2’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:496: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:496: error: ‘struct compat_floppy_fdc_state’ no tiene un miembro llamado ‘spec2’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:496: error: ‘struct compat_floppy_fdc_state’ no tiene un miembro llamado ‘spec2’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:496: error: ‘struct compat_floppy_fdc_state’ no tiene un miembro llamado ‘spec2’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:496: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:496: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:496: error: ‘struct compat_floppy_fdc_state’ no tiene un miembro llamado ‘spec2’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:497: error: ‘struct compat_floppy_fdc_state’ no tiene un miembro llamado ‘dtr’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:497: error: ‘struct compat_floppy_fdc_state’ no tiene un miembro llamado ‘dtr’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:497: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:497: error: ‘struct compat_floppy_fdc_state’ no tiene un miembro llamado ‘dtr’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:497: error: ‘struct compat_floppy_fdc_state’ no tiene un miembro llamado ‘dtr’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:497: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:497: error: ‘struct compat_floppy_fdc_state’ no tiene un miembro llamado ‘dtr’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:497: error: ‘struct compat_floppy_fdc_state’ no tiene un miembro llamado ‘dtr’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:497: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:497: error: ‘struct compat_floppy_fdc_state’ no tiene un miembro llamado ‘dtr’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:497: error: ‘struct compat_floppy_fdc_state’ no tiene un miembro llamado ‘dtr’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:497: error: ‘struct compat_floppy_fdc_state’ no tiene un miembro llamado ‘dtr’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:497: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:497: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:497: error: ‘struct compat_floppy_fdc_state’ no tiene un miembro llamado ‘dtr’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:498: error: ‘struct compat_floppy_fdc_state’ no tiene un miembro llamado ‘version’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:498: error: ‘struct compat_floppy_fdc_state’ no tiene un miembro llamado ‘version’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:498: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:498: error: ‘struct compat_floppy_fdc_state’ no tiene un miembro llamado ‘version’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:498: error: ‘struct compat_floppy_fdc_state’ no tiene un miembro llamado ‘version’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:498: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:498: error: ‘struct compat_floppy_fdc_state’ no tiene un miembro llamado ‘version’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:498: error: ‘struct compat_floppy_fdc_state’ no tiene un miembro llamado ‘version’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:498: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:498: error: ‘struct compat_floppy_fdc_state’ no tiene un miembro llamado ‘version’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:498: error: ‘struct compat_floppy_fdc_state’ no tiene un miembro llamado ‘version’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:498: error: ‘struct compat_floppy_fdc_state’ no tiene un miembro llamado ‘version’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:498: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:498: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:498: error: ‘struct compat_floppy_fdc_state’ no tiene un miembro llamado ‘version’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:499: error: ‘struct compat_floppy_fdc_state’ no tiene un miembro llamado ‘dor’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:499: error: ‘struct compat_floppy_fdc_state’ no tiene un miembro llamado ‘dor’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:499: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:499: error: ‘struct compat_floppy_fdc_state’ no tiene un miembro llamado ‘dor’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:499: error: ‘struct compat_floppy_fdc_state’ no tiene un miembro llamado ‘dor’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:499: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:499: error: ‘struct compat_floppy_fdc_state’ no tiene un miembro llamado ‘dor’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:499: error: ‘struct compat_floppy_fdc_state’ no tiene un miembro llamado ‘dor’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:499: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:499: error: ‘struct compat_floppy_fdc_state’ no tiene un miembro llamado ‘dor’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:499: error: ‘struct compat_floppy_fdc_state’ no tiene un miembro llamado ‘dor’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:499: error: ‘struct compat_floppy_fdc_state’ no tiene un miembro llamado ‘dor’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:499: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:499: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:499: error: ‘struct compat_floppy_fdc_state’ no tiene un miembro llamado ‘dor’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:500: error: ‘struct compat_floppy_fdc_state’ no tiene un miembro llamado ‘address’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:500: error: ‘struct compat_floppy_fdc_state’ no tiene un miembro llamado ‘address’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:500: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:500: error: ‘struct compat_floppy_fdc_state’ no tiene un miembro llamado ‘address’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:500: error: ‘struct compat_floppy_fdc_state’ no tiene un miembro llamado ‘address’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:500: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:500: error: ‘struct compat_floppy_fdc_state’ no tiene un miembro llamado ‘address’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:500: error: ‘struct compat_floppy_fdc_state’ no tiene un miembro llamado ‘address’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:500: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:500: error: ‘struct compat_floppy_fdc_state’ no tiene un miembro llamado ‘address’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:500: error: ‘struct compat_floppy_fdc_state’ no tiene un miembro llamado ‘address’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:500: error: ‘struct compat_floppy_fdc_state’ no tiene un miembro llamado ‘address’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:500: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:500: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:500: error: ‘struct compat_floppy_fdc_state’ no tiene un miembro llamado ‘address’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:501: error: ‘struct compat_floppy_fdc_state’ no tiene un miembro llamado ‘address’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:501: error: ‘struct compat_floppy_fdc_state’ no tiene un miembro llamado ‘address’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:503: error: ‘struct compat_floppy_fdc_state’ no tiene un miembro llamado ‘driver_version’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:503: error: ‘struct compat_floppy_fdc_state’ no tiene un miembro llamado ‘driver_version’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:503: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:503: error: ‘struct compat_floppy_fdc_state’ no tiene un miembro llamado ‘driver_version’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:503: error: ‘struct compat_floppy_fdc_state’ no tiene un miembro llamado ‘driver_version’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:503: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:503: error: ‘struct compat_floppy_fdc_state’ no tiene un miembro llamado ‘driver_version’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:503: error: ‘struct compat_floppy_fdc_state’ no tiene un miembro llamado ‘driver_version’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:503: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:503: error: ‘struct compat_floppy_fdc_state’ no tiene un miembro llamado ‘driver_version’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:503: error: ‘struct compat_floppy_fdc_state’ no tiene un miembro llamado ‘driver_version’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:503: error: ‘struct compat_floppy_fdc_state’ no tiene un miembro llamado ‘driver_version’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:503: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:503: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:503: error: ‘struct compat_floppy_fdc_state’ no tiene un miembro llamado ‘driver_version’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:504: error: ‘struct compat_floppy_fdc_state’ no tiene un miembro llamado ‘track’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:512: aviso: la asignación crea un puntero desde un entero sin una conversión
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:514: error: ‘struct compat_floppy_write_errors’ no tiene un miembro llamado ‘first_error_sector’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:514: error: ‘struct compat_floppy_write_errors’ no tiene un miembro llamado ‘first_error_sector’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:514: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:514: error: ‘struct compat_floppy_write_errors’ no tiene un miembro llamado ‘first_error_sector’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:514: error: ‘struct compat_floppy_write_errors’ no tiene un miembro llamado ‘first_error_sector’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:514: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:514: error: ‘struct compat_floppy_write_errors’ no tiene un miembro llamado ‘first_error_sector’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:514: error: ‘struct compat_floppy_write_errors’ no tiene un miembro llamado ‘first_error_sector’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:514: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:514: error: ‘struct compat_floppy_write_errors’ no tiene un miembro llamado ‘first_error_sector’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:514: error: ‘struct compat_floppy_write_errors’ no tiene un miembro llamado ‘first_error_sector’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:514: error: ‘struct compat_floppy_write_errors’ no tiene un miembro llamado ‘first_error_sector’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:514: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:514: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:514: error: ‘struct compat_floppy_write_errors’ no tiene un miembro llamado ‘first_error_sector’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:515: error: ‘struct compat_floppy_write_errors’ no tiene un miembro llamado ‘first_error_generation’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:515: error: ‘struct compat_floppy_write_errors’ no tiene un miembro llamado ‘first_error_generation’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:515: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:515: error: ‘struct compat_floppy_write_errors’ no tiene un miembro llamado ‘first_error_generation’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:515: error: ‘struct compat_floppy_write_errors’ no tiene un miembro llamado ‘first_error_generation’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:515: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:515: error: ‘struct compat_floppy_write_errors’ no tiene un miembro llamado ‘first_error_generation’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:515: error: ‘struct compat_floppy_write_errors’ no tiene un miembro llamado ‘first_error_generation’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:515: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:515: error: ‘struct compat_floppy_write_errors’ no tiene un miembro llamado ‘first_error_generation’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:515: error: ‘struct compat_floppy_write_errors’ no tiene un miembro llamado ‘first_error_generation’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:515: error: ‘struct compat_floppy_write_errors’ no tiene un miembro llamado ‘first_error_generation’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:515: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:515: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:515: error: ‘struct compat_floppy_write_errors’ no tiene un miembro llamado ‘first_error_generation’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:516: error: ‘struct compat_floppy_write_errors’ no tiene un miembro llamado ‘last_error_sector’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:516: error: ‘struct compat_floppy_write_errors’ no tiene un miembro llamado ‘last_error_sector’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:516: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:516: error: ‘struct compat_floppy_write_errors’ no tiene un miembro llamado ‘last_error_sector’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:516: error: ‘struct compat_floppy_write_errors’ no tiene un miembro llamado ‘last_error_sector’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:516: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:516: error: ‘struct compat_floppy_write_errors’ no tiene un miembro llamado ‘last_error_sector’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:516: error: ‘struct compat_floppy_write_errors’ no tiene un miembro llamado ‘last_error_sector’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:516: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:516: error: ‘struct compat_floppy_write_errors’ no tiene un miembro llamado ‘last_error_sector’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:516: error: ‘struct compat_floppy_write_errors’ no tiene un miembro llamado ‘last_error_sector’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:516: error: ‘struct compat_floppy_write_errors’ no tiene un miembro llamado ‘last_error_sector’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:516: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:516: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:516: error: ‘struct compat_floppy_write_errors’ no tiene un miembro llamado ‘last_error_sector’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:517: error: ‘struct compat_floppy_write_errors’ no tiene un miembro llamado ‘last_error_generation’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:517: error: ‘struct compat_floppy_write_errors’ no tiene un miembro llamado ‘last_error_generation’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:517: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:517: error: ‘struct compat_floppy_write_errors’ no tiene un miembro llamado ‘last_error_generation’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:517: error: ‘struct compat_floppy_write_errors’ no tiene un miembro llamado ‘last_error_generation’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:517: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:517: error: ‘struct compat_floppy_write_errors’ no tiene un miembro llamado ‘last_error_generation’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:517: error: ‘struct compat_floppy_write_errors’ no tiene un miembro llamado ‘last_error_generation’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:517: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:517: error: ‘struct compat_floppy_write_errors’ no tiene un miembro llamado ‘last_error_generation’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:517: error: ‘struct compat_floppy_write_errors’ no tiene un miembro llamado ‘last_error_generation’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:517: error: ‘struct compat_floppy_write_errors’ no tiene un miembro llamado ‘last_error_generation’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:517: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:517: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:517: error: ‘struct compat_floppy_write_errors’ no tiene un miembro llamado ‘last_error_generation’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:518: error: ‘struct compat_floppy_write_errors’ no tiene un miembro llamado ‘badness’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:518: error: ‘struct compat_floppy_write_errors’ no tiene un miembro llamado ‘badness’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:518: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:518: error: ‘struct compat_floppy_write_errors’ no tiene un miembro llamado ‘badness’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:518: error: ‘struct compat_floppy_write_errors’ no tiene un miembro llamado ‘badness’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:518: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:518: error: ‘struct compat_floppy_write_errors’ no tiene un miembro llamado ‘badness’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:518: error: ‘struct compat_floppy_write_errors’ no tiene un miembro llamado ‘badness’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:518: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:518: error: ‘struct compat_floppy_write_errors’ no tiene un miembro llamado ‘badness’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:518: error: ‘struct compat_floppy_write_errors’ no tiene un miembro llamado ‘badness’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:518: error: ‘struct compat_floppy_write_errors’ no tiene un miembro llamado ‘badness’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:518: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:518: aviso: el tipo de dato por defecto es ‘int’ en la declaración de ‘type name’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:518: error: ‘struct compat_floppy_write_errors’ no tiene un miembro llamado ‘badness’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c: En el nivel principal:
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:537: error: expected specifier-qualifier-list before ‘compat_u64’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c: En la función ‘compat_blk_trace_setup’:
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:561: error: ‘struct compat_blk_user_trace_setup’ no tiene un miembro llamado ‘start_lba’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:562: error: ‘struct compat_blk_user_trace_setup’ no tiene un miembro llamado ‘end_lba’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:563: error: ‘struct compat_blk_user_trace_setup’ no tiene un miembro llamado ‘pid’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c: En la función ‘compat_blkdev_locked_ioctl’:
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:759: error: demasiados argumentos para la función ‘compat_put_ulong’
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:765: aviso: el paso del argumento 2 de ‘compat_blk_trace_setup’ crea un puntero desde un entero sin una conversión
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:769: aviso: el paso del argumento 3 de ‘blk_trace_ioctl’ crea un puntero desde un entero sin una conversión
/home/alex/kernel/linux-2.6/block/compat_ioctl.c: En la función ‘compat_blkdev_ioctl’:
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:786: aviso: el paso del argumento 3 de ‘compat_hdio_getgeo’ crea un puntero desde un entero sin una conversión
/home/alex/kernel/linux-2.6/block/compat_ioctl.c:800: aviso: el paso del argumento 4 de ‘compat_blkpg_ioctl’ crea un puntero desde un entero sin una conversión
make[2]: *** [block/compat_ioctl.o] Error 1
make[1]: *** [block] Error 2
make: *** [_all] Error 2

 Y el config
 #
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.23
# Fri Oct 12 20:05:22 2007
#
CONFIG_X86_32=y
CONFIG_GENERIC_TIME=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_SEMAPHORE_SLEEPERS=y
CONFIG_X86=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_QUICKLIST=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_DMI=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
# CONFIG_BSD_PROCESS_ACCT is not set
# CONFIG_TASKSTATS is not set
# CONFIG_USER_NS is not set
# CONFIG_AUDIT is not set
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=15
# CONFIG_CPUSETS is not set
CONFIG_SYSFS_DEPRECATED=y
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
# CONFIG_EMBEDDED is not set
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
# CONFIG_KALLSYMS_EXTRA_PASS is not set
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_ANON_INODES=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_SLUB_DEBUG=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
CONFIG_RT_MUTEXES=y
# CONFIG_TINY_SHMEM is not set
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
CONFIG_MODULE_UNLOAD=y
# CONFIG_MODULE_FORCE_UNLOAD is not set
CONFIG_MODVERSIONS=y
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_KMOD=y
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
# CONFIG_LBD is not set
CONFIG_BLK_DEV_IO_TRACE=y
# CONFIG_LSF is not set
CONFIG_BLK_DEV_BSG=y
CONFIG_BLOCK_COMPAT=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_AS=y
CONFIG_IOSCHED_DEADLINE=m
CONFIG_IOSCHED_CFQ=m
CONFIG_DEFAULT_AS=y
# CONFIG_DEFAULT_DEADLINE is not set
# CONFIG_DEFAULT_CFQ is not set
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="anticipatory"

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_SMP=y
CONFIG_X86_PC=y
# CONFIG_X86_ELAN is not set
# CONFIG_X86_VOYAGER is not set
# CONFIG_X86_NUMAQ is not set
# CONFIG_X86_SUMMIT is not set
# CONFIG_X86_BIGSMP is not set
# CONFIG_X86_VISWS is not set
# CONFIG_X86_GENERICARCH is not set
# CONFIG_X86_ES7000 is not set
# CONFIG_PARAVIRT is not set
# CONFIG_M386 is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
# CONFIG_MPENTIUMM is not set
# CONFIG_MCORE2 is not set
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
CONFIG_MK8=y
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP2 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_X86_GENERIC is not set
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_XADD=y
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
# CONFIG_ARCH_HAS_ILOG2_U32 is not set
# CONFIG_ARCH_HAS_ILOG2_U64 is not set
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INVLPG=y
CONFIG_X86_BSWAP=y
CONFIG_X86_POPAD_OK=y
CONFIG_X86_GOOD_APIC=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_MINIMUM_CPU_FAMILY=4
CONFIG_HPET_TIMER=y
CONFIG_NR_CPUS=2
# CONFIG_SCHED_SMT is not set
CONFIG_SCHED_MC=y
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_PREEMPT_BKL=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_MCE=y
CONFIG_X86_MCE_NONFATAL=y
# CONFIG_X86_MCE_P4THERMAL is not set
CONFIG_VM86=y
# CONFIG_TOSHIBA is not set
# CONFIG_I8K is not set
# CONFIG_X86_REBOOTFIXUPS is not set
# CONFIG_MICROCODE is not set
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y

#
# Firmware Drivers
#
# CONFIG_EDD is not set
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
# CONFIG_DMIID is not set
# CONFIG_NOHIGHMEM is not set
CONFIG_HIGHMEM4G=y
# CONFIG_HIGHMEM64G is not set
CONFIG_PAGE_OFFSET=0xC0000000
CONFIG_HIGHMEM=y
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ARCH_POPULATES_NODE_MAP=y
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_FLATMEM_MANUAL=y
# CONFIG_DISCONTIGMEM_MANUAL is not set
# CONFIG_SPARSEMEM_MANUAL is not set
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
CONFIG_SPARSEMEM_STATIC=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_RESOURCES_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_NR_QUICK=1
CONFIG_VIRT_TO_BUS=y
# CONFIG_HIGHPTE is not set
# CONFIG_MATH_EMULATION is not set
CONFIG_MTRR=y
# CONFIG_EFI is not set
CONFIG_IRQBALANCE=y
# CONFIG_SECCOMP is not set
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
# CONFIG_KEXEC is not set
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x100000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x100000
# CONFIG_HOTPLUG_CPU is not set
CONFIG_COMPAT_VDSO=y
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management options (ACPI, APM)
#
CONFIG_PM=y
# CONFIG_PM_LEGACY is not set
# CONFIG_PM_DEBUG is not set
CONFIG_SUSPEND_SMP_POSSIBLE=y
# CONFIG_SUSPEND is not set
CONFIG_HIBERNATION_SMP_POSSIBLE=y
# CONFIG_HIBERNATION is not set
CONFIG_ACPI=y
# CONFIG_ACPI_PROCFS is not set
# CONFIG_ACPI_PROC_EVENT is not set
# CONFIG_ACPI_AC is not set
# CONFIG_ACPI_BATTERY is not set
CONFIG_ACPI_BUTTON=m
# CONFIG_ACPI_VIDEO is not set
CONFIG_ACPI_FAN=m
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=m
CONFIG_ACPI_THERMAL=m
# CONFIG_ACPI_ASUS is not set
# CONFIG_ACPI_TOSHIBA is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_EC=y
CONFIG_ACPI_POWER=y
CONFIG_ACPI_SYSTEM=y
CONFIG_X86_PM_TIMER=y
# CONFIG_ACPI_CONTAINER is not set
# CONFIG_ACPI_SBS is not set

#
# CPU Frequency scaling
#
# CONFIG_CPU_FREQ is not set

#
# Bus options (PCI, PCMCIA, EISA, MCA, ISA)
#
CONFIG_PCI=y
# CONFIG_PCI_GOBIOS is not set
# CONFIG_PCI_GOMMCONFIG is not set
# CONFIG_PCI_GODIRECT is not set
CONFIG_PCI_GOANY=y
CONFIG_PCI_BIOS=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
CONFIG_PCIEPORTBUS=y
CONFIG_PCIEAER=y
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
# CONFIG_PCI_DEBUG is not set
CONFIG_HT_IRQ=y
CONFIG_ISA_DMA_API=y
# CONFIG_ISA is not set
# CONFIG_MCA is not set
# CONFIG_SCx200 is not set
CONFIG_K8_NB=y

#
# PCCARD (PCMCIA/CardBus) support
#
# CONFIG_PCCARD is not set
# CONFIG_HOTPLUG_PCI is not set

#
# Executable file formats
#
CONFIG_BINFMT_ELF=y
# CONFIG_BINFMT_AOUT is not set
CONFIG_BINFMT_MISC=m

#
# Networking
#
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=m
CONFIG_PACKET_MMAP=y
CONFIG_UNIX=m
CONFIG_XFRM=y
CONFIG_XFRM_USER=m
# CONFIG_XFRM_SUB_POLICY is not set
# CONFIG_XFRM_MIGRATE is not set
CONFIG_NET_KEY=m
# CONFIG_NET_KEY_MIGRATE is not set
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
CONFIG_ASK_IP_FIB_HASH=y
# CONFIG_IP_FIB_TRIE is not set
CONFIG_IP_FIB_HASH=y
CONFIG_IP_MULTIPLE_TABLES=y
CONFIG_IP_ROUTE_MULTIPATH=y
# CONFIG_IP_ROUTE_VERBOSE is not set
# CONFIG_IP_PNP is not set
# CONFIG_NET_IPIP is not set
# CONFIG_NET_IPGRE is not set
# CONFIG_IP_MROUTE is not set
# CONFIG_ARPD is not set
# CONFIG_SYN_COOKIES is not set
CONFIG_INET_AH=m
CONFIG_INET_ESP=m
CONFIG_INET_IPCOMP=m
CONFIG_INET_XFRM_TUNNEL=m
CONFIG_INET_TUNNEL=m
CONFIG_INET_XFRM_MODE_TRANSPORT=m
CONFIG_INET_XFRM_MODE_TUNNEL=m
CONFIG_INET_XFRM_MODE_BEET=m
CONFIG_INET_LRO=y
CONFIG_INET_DIAG=m
CONFIG_INET_TCP_DIAG=m
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_TCP_MD5SIG is not set
# CONFIG_IP_VS is not set
CONFIG_IPV6=m
CONFIG_IPV6_PRIVACY=y
# CONFIG_IPV6_ROUTER_PREF is not set
# CONFIG_IPV6_OPTIMISTIC_DAD is not set
CONFIG_INET6_AH=m
CONFIG_INET6_ESP=m
CONFIG_INET6_IPCOMP=m
# CONFIG_IPV6_MIP6 is not set
CONFIG_INET6_XFRM_TUNNEL=m
CONFIG_INET6_TUNNEL=m
CONFIG_INET6_XFRM_MODE_TRANSPORT=m
CONFIG_INET6_XFRM_MODE_TUNNEL=m
CONFIG_INET6_XFRM_MODE_BEET=m
# CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION is not set
CONFIG_IPV6_SIT=m
# CONFIG_IPV6_TUNNEL is not set
# CONFIG_IPV6_MULTIPLE_TABLES is not set
# CONFIG_NETLABEL is not set
# CONFIG_NETWORK_SECMARK is not set
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
# CONFIG_BRIDGE_NETFILTER is not set

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=m
CONFIG_NETFILTER_NETLINK_QUEUE=m
CONFIG_NETFILTER_NETLINK_LOG=m
CONFIG_NF_CONNTRACK_ENABLED=m
CONFIG_NF_CONNTRACK=m
CONFIG_NF_CT_ACCT=y
CONFIG_NF_CONNTRACK_MARK=y
# CONFIG_NF_CONNTRACK_EVENTS is not set
CONFIG_NF_CT_PROTO_SCTP=m
# CONFIG_NF_CT_PROTO_UDPLITE is not set
# CONFIG_NF_CONNTRACK_AMANDA is not set
CONFIG_NF_CONNTRACK_FTP=m
# CONFIG_NF_CONNTRACK_H323 is not set
CONFIG_NF_CONNTRACK_IRC=m
# CONFIG_NF_CONNTRACK_NETBIOS_NS is not set
# CONFIG_NF_CONNTRACK_PPTP is not set
# CONFIG_NF_CONNTRACK_SANE is not set
CONFIG_NF_CONNTRACK_SIP=m
CONFIG_NF_CONNTRACK_TFTP=m
# CONFIG_NF_CT_NETLINK is not set
CONFIG_NETFILTER_XTABLES=m
CONFIG_NETFILTER_XT_TARGET_CLASSIFY=m
CONFIG_NETFILTER_XT_TARGET_CONNMARK=m
CONFIG_NETFILTER_XT_TARGET_DSCP=m
CONFIG_NETFILTER_XT_TARGET_MARK=m
CONFIG_NETFILTER_XT_TARGET_NFQUEUE=m
CONFIG_NETFILTER_XT_TARGET_NFLOG=m
CONFIG_NETFILTER_XT_TARGET_NOTRACK=m
CONFIG_NETFILTER_XT_TARGET_TRACE=m
CONFIG_NETFILTER_XT_TARGET_TCPMSS=m
CONFIG_NETFILTER_XT_MATCH_COMMENT=m
CONFIG_NETFILTER_XT_MATCH_CONNBYTES=m
CONFIG_NETFILTER_XT_MATCH_CONNLIMIT=m
CONFIG_NETFILTER_XT_MATCH_CONNMARK=m
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=m
CONFIG_NETFILTER_XT_MATCH_DCCP=m
CONFIG_NETFILTER_XT_MATCH_DSCP=m
CONFIG_NETFILTER_XT_MATCH_ESP=m
CONFIG_NETFILTER_XT_MATCH_HELPER=m
CONFIG_NETFILTER_XT_MATCH_LENGTH=m
CONFIG_NETFILTER_XT_MATCH_LIMIT=m
CONFIG_NETFILTER_XT_MATCH_MAC=m
CONFIG_NETFILTER_XT_MATCH_MARK=m
CONFIG_NETFILTER_XT_MATCH_POLICY=m
CONFIG_NETFILTER_XT_MATCH_MULTIPORT=m
CONFIG_NETFILTER_XT_MATCH_PKTTYPE=m
CONFIG_NETFILTER_XT_MATCH_QUOTA=m
CONFIG_NETFILTER_XT_MATCH_REALM=m
CONFIG_NETFILTER_XT_MATCH_SCTP=m
CONFIG_NETFILTER_XT_MATCH_STATE=m
CONFIG_NETFILTER_XT_MATCH_STATISTIC=m
CONFIG_NETFILTER_XT_MATCH_STRING=m
CONFIG_NETFILTER_XT_MATCH_TCPMSS=m
CONFIG_NETFILTER_XT_MATCH_TIME=m
CONFIG_NETFILTER_XT_MATCH_U32=m
CONFIG_NETFILTER_XT_MATCH_HASHLIMIT=m

#
# IP: Netfilter Configuration
#
CONFIG_NF_CONNTRACK_IPV4=m
CONFIG_NF_CONNTRACK_PROC_COMPAT=y
# CONFIG_IP_NF_QUEUE is not set
CONFIG_IP_NF_IPTABLES=m
CONFIG_IP_NF_MATCH_IPRANGE=m
CONFIG_IP_NF_MATCH_TOS=m
CONFIG_IP_NF_MATCH_RECENT=m
CONFIG_IP_NF_MATCH_ECN=m
CONFIG_IP_NF_MATCH_AH=m
CONFIG_IP_NF_MATCH_TTL=m
CONFIG_IP_NF_MATCH_OWNER=m
CONFIG_IP_NF_MATCH_ADDRTYPE=m
CONFIG_IP_NF_FILTER=m
CONFIG_IP_NF_TARGET_REJECT=m
CONFIG_IP_NF_TARGET_LOG=m
CONFIG_IP_NF_TARGET_ULOG=m
CONFIG_NF_NAT=m
CONFIG_NF_NAT_NEEDED=y
CONFIG_IP_NF_TARGET_MASQUERADE=m
CONFIG_IP_NF_TARGET_REDIRECT=m
CONFIG_IP_NF_TARGET_NETMAP=m
CONFIG_IP_NF_TARGET_SAME=m
CONFIG_NF_NAT_SNMP_BASIC=m
CONFIG_NF_NAT_FTP=m
CONFIG_NF_NAT_IRC=m
CONFIG_NF_NAT_TFTP=m
# CONFIG_NF_NAT_AMANDA is not set
# CONFIG_NF_NAT_PPTP is not set
# CONFIG_NF_NAT_H323 is not set
CONFIG_NF_NAT_SIP=m
CONFIG_IP_NF_MANGLE=m
CONFIG_IP_NF_TARGET_TOS=m
CONFIG_IP_NF_TARGET_ECN=m
CONFIG_IP_NF_TARGET_TTL=m
CONFIG_IP_NF_TARGET_CLUSTERIP=m
CONFIG_IP_NF_RAW=m
CONFIG_IP_NF_ARPTABLES=m
CONFIG_IP_NF_ARPFILTER=m
CONFIG_IP_NF_ARP_MANGLE=m

#
# IPv6: Netfilter Configuration (EXPERIMENTAL)
#
CONFIG_NF_CONNTRACK_IPV6=m
CONFIG_IP6_NF_QUEUE=m
CONFIG_IP6_NF_IPTABLES=m
CONFIG_IP6_NF_MATCH_RT=m
CONFIG_IP6_NF_MATCH_OPTS=m
CONFIG_IP6_NF_MATCH_FRAG=m
CONFIG_IP6_NF_MATCH_HL=m
CONFIG_IP6_NF_MATCH_OWNER=m
CONFIG_IP6_NF_MATCH_IPV6HEADER=m
CONFIG_IP6_NF_MATCH_AH=m
CONFIG_IP6_NF_MATCH_MH=m
CONFIG_IP6_NF_MATCH_EUI64=m
CONFIG_IP6_NF_FILTER=m
CONFIG_IP6_NF_TARGET_LOG=m
CONFIG_IP6_NF_TARGET_REJECT=m
CONFIG_IP6_NF_MANGLE=m
CONFIG_IP6_NF_TARGET_HL=m
CONFIG_IP6_NF_RAW=m

#
# Bridge: Netfilter Configuration
#
# CONFIG_BRIDGE_NF_EBTABLES is not set
# CONFIG_IP_DCCP is not set
CONFIG_IP_SCTP=m
# CONFIG_SCTP_DBG_MSG is not set
# CONFIG_SCTP_DBG_OBJCNT is not set
# CONFIG_SCTP_HMAC_NONE is not set
# CONFIG_SCTP_HMAC_SHA1 is not set
CONFIG_SCTP_HMAC_MD5=y
# CONFIG_TIPC is not set
CONFIG_ATM=m
CONFIG_ATM_CLIP=m
CONFIG_ATM_CLIP_NO_ICMP=y
CONFIG_ATM_LANE=m
CONFIG_ATM_MPOA=m
CONFIG_ATM_BR2684=m
CONFIG_ATM_BR2684_IPFILTER=y
CONFIG_BRIDGE=m
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
CONFIG_LLC=m
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_ECONET is not set
# CONFIG_WAN_ROUTER is not set

#
# QoS and/or fair queueing
#
# CONFIG_NET_SCHED is not set
CONFIG_NET_SCH_FIFO=y
CONFIG_NET_CLS_ROUTE=y

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_HAMRADIO is not set
# CONFIG_IRDA is not set
CONFIG_BT=m
CONFIG_BT_L2CAP=m
CONFIG_BT_SCO=m
CONFIG_BT_RFCOMM=m
CONFIG_BT_RFCOMM_TTY=y
CONFIG_BT_BNEP=m
CONFIG_BT_BNEP_MC_FILTER=y
CONFIG_BT_BNEP_PROTO_FILTER=y
CONFIG_BT_HIDP=m

#
# Bluetooth device drivers
#
CONFIG_BT_HCIUSB=m
CONFIG_BT_HCIUSB_SCO=y
CONFIG_BT_HCIUART=m
CONFIG_BT_HCIUART_H4=y
CONFIG_BT_HCIUART_BCSP=y
CONFIG_BT_HCIBCM203X=m
CONFIG_BT_HCIBPA10X=m
CONFIG_BT_HCIBFUSB=m
CONFIG_BT_HCIVHCI=m
# CONFIG_AF_RXRPC is not set
CONFIG_FIB_RULES=y

#
# Wireless
#
CONFIG_CFG80211=m
CONFIG_NL80211=y
CONFIG_WIRELESS_EXT=y
CONFIG_MAC80211=m
CONFIG_MAC80211_LEDS=y
# CONFIG_MAC80211_DEBUGFS is not set
CONFIG_MAC80211_DEBUG=y
# CONFIG_MAC80211_VERBOSE_DEBUG is not set
# CONFIG_MAC80211_LOWTX_FRAME_DUMP is not set
CONFIG_TKIP_DEBUG=y
# CONFIG_MAC80211_DEBUG_COUNTERS is not set
# CONFIG_MAC80211_IBSS_DEBUG is not set
# CONFIG_MAC80211_VERBOSE_PS_DEBUG is not set
CONFIG_IEEE80211=y
# CONFIG_IEEE80211_DEBUG is not set
CONFIG_IEEE80211_CRYPT_WEP=m
CONFIG_IEEE80211_CRYPT_CCMP=m
CONFIG_IEEE80211_CRYPT_TKIP=m
CONFIG_IEEE80211_SOFTMAC=m
# CONFIG_IEEE80211_SOFTMAC_DEBUG is not set
CONFIG_RFKILL=m
CONFIG_RFKILL_INPUT=m
CONFIG_RFKILL_LEDS=y
CONFIG_NET_9P=m
# CONFIG_NET_9P_DEBUG is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
CONFIG_CONNECTOR=m
# CONFIG_MTD is not set
CONFIG_PARPORT=m
CONFIG_PARPORT_PC=m
CONFIG_PARPORT_SERIAL=m
CONFIG_PARPORT_PC_FIFO=y
CONFIG_PARPORT_PC_SUPERIO=y
# CONFIG_PARPORT_GSC is not set
# CONFIG_PARPORT_AX88796 is not set
CONFIG_PARPORT_1284=y
CONFIG_PNP=y
# CONFIG_PNP_DEBUG is not set

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_FD=m
# CONFIG_PARIDE is not set
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=m
CONFIG_BLK_DEV_CRYPTOLOOP=m
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_UB is not set
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=8192
CONFIG_BLK_DEV_RAM_BLOCKSIZE=1024
CONFIG_CDROM_PKTCDVD=m
CONFIG_CDROM_PKTCDVD_BUFFERS=8
CONFIG_CDROM_PKTCDVD_WCACHE=y
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_MISC_DEVICES is not set
CONFIG_EEPROM_93CX6=m
# CONFIG_IDE is not set

#
# SCSI device support
#
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_TGT is not set
# CONFIG_SCSI_NETLINK is not set
# CONFIG_SCSI_PROC_FS is not set

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
CONFIG_BLK_DEV_SR=m
CONFIG_BLK_DEV_SR_VENDOR=y
CONFIG_CHR_DEV_SG=m
# CONFIG_CHR_DEV_SCH is not set

#
# Some SCSI devices (e.g. CD jukebox) support multiple LUNs
#
# CONFIG_SCSI_MULTI_LUN is not set
# CONFIG_SCSI_CONSTANTS is not set
# CONFIG_SCSI_LOGGING is not set
# CONFIG_SCSI_SCAN_ASYNC is not set
CONFIG_SCSI_WAIT_SCAN=m

#
# SCSI Transports
#
# CONFIG_SCSI_SPI_ATTRS is not set
# CONFIG_SCSI_FC_ATTRS is not set
# CONFIG_SCSI_ISCSI_ATTRS is not set
# CONFIG_SCSI_SAS_ATTRS is not set
# CONFIG_SCSI_SAS_LIBSAS is not set
# CONFIG_SCSI_LOWLEVEL is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_ACPI=y
CONFIG_SATA_AHCI=y
# CONFIG_SATA_SVW is not set
# CONFIG_ATA_PIIX is not set
# CONFIG_SATA_MV is not set
# CONFIG_SATA_NV is not set
# CONFIG_PDC_ADMA is not set
# CONFIG_SATA_QSTOR is not set
# CONFIG_SATA_PROMISE is not set
# CONFIG_SATA_SX4 is not set
# CONFIG_SATA_SIL is not set
CONFIG_SATA_SIL24=m
# CONFIG_SATA_SIS is not set
CONFIG_SATA_ULI=m
CONFIG_SATA_VIA=m
# CONFIG_SATA_VITESSE is not set
# CONFIG_SATA_INIC162X is not set
CONFIG_PATA_ACPI=m
CONFIG_PATA_ALI=y
# CONFIG_PATA_AMD is not set
# CONFIG_PATA_ARTOP is not set
# CONFIG_PATA_ATIIXP is not set
# CONFIG_PATA_CMD640_PCI is not set
# CONFIG_PATA_CMD64X is not set
# CONFIG_PATA_CS5520 is not set
# CONFIG_PATA_CS5530 is not set
# CONFIG_PATA_CS5535 is not set
# CONFIG_PATA_CYPRESS is not set
# CONFIG_PATA_EFAR is not set
CONFIG_ATA_GENERIC=m
# CONFIG_PATA_HPT366 is not set
# CONFIG_PATA_HPT37X is not set
# CONFIG_PATA_HPT3X2N is not set
# CONFIG_PATA_HPT3X3 is not set
# CONFIG_PATA_IT821X is not set
# CONFIG_PATA_IT8213 is not set
# CONFIG_PATA_JMICRON is not set
# CONFIG_PATA_TRIFLEX is not set
# CONFIG_PATA_MARVELL is not set
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_OLDPIIX is not set
CONFIG_PATA_NETCELL=m
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_NS87415 is not set
# CONFIG_PATA_OPTI is not set
# CONFIG_PATA_OPTIDMA is not set
# CONFIG_PATA_PDC_OLD is not set
# CONFIG_PATA_RADISYS is not set
# CONFIG_PATA_RZ1000 is not set
# CONFIG_PATA_SC1200 is not set
# CONFIG_PATA_SERVERWORKS is not set
# CONFIG_PATA_PDC2027X is not set
# CONFIG_PATA_SIL680 is not set
# CONFIG_PATA_SIS is not set
CONFIG_PATA_VIA=m
# CONFIG_PATA_WINBOND is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=m
CONFIG_MD_LINEAR=m
CONFIG_MD_RAID0=m
CONFIG_MD_RAID1=m
CONFIG_MD_RAID10=m
CONFIG_MD_RAID456=m
CONFIG_MD_RAID5_RESHAPE=y
CONFIG_MD_MULTIPATH=m
CONFIG_MD_FAULTY=m
CONFIG_BLK_DEV_DM=m
# CONFIG_DM_DEBUG is not set
CONFIG_DM_CRYPT=m
# CONFIG_DM_SNAPSHOT is not set
# CONFIG_DM_MIRROR is not set
# CONFIG_DM_ZERO is not set
# CONFIG_DM_MULTIPATH is not set
# CONFIG_DM_DELAY is not set

#
# Fusion MPT device support
#
# CONFIG_FUSION is not set
# CONFIG_FUSION_SPI is not set
# CONFIG_FUSION_FC is not set
# CONFIG_FUSION_SAS is not set

#
# IEEE 1394 (FireWire) support
#
CONFIG_FIREWIRE=m
CONFIG_FIREWIRE_OHCI=m
CONFIG_FIREWIRE_SBP2=m
# CONFIG_IEEE1394 is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
CONFIG_NETDEVICES_MULTIQUEUE=y
CONFIG_DUMMY=m
CONFIG_BONDING=m
# CONFIG_MACVLAN is not set
# CONFIG_EQUALIZER is not set
CONFIG_TUN=m
CONFIG_VETH=m
# CONFIG_NET_SB1000 is not set
# CONFIG_IP1000 is not set
# CONFIG_ARCNET is not set
CONFIG_PHYLIB=m

#
# MII PHY device drivers
#
CONFIG_MARVELL_PHY=m
CONFIG_DAVICOM_PHY=m
CONFIG_QSEMI_PHY=m
CONFIG_LXT_PHY=m
CONFIG_CICADA_PHY=m
CONFIG_VITESSE_PHY=m
CONFIG_SMSC_PHY=m
CONFIG_BROADCOM_PHY=m
CONFIG_ICPLUS_PHY=m
CONFIG_FIXED_PHY=m
CONFIG_FIXED_MII_10_FDX=y
CONFIG_FIXED_MII_100_FDX=y
# CONFIG_FIXED_MII_1000_FDX is not set
CONFIG_FIXED_MII_AMNT=1
# CONFIG_MDIO_BITBANG is not set
CONFIG_NET_ETHERNET=y
CONFIG_MII=m
# CONFIG_HAPPYMEAL is not set
# CONFIG_SUNGEM is not set
# CONFIG_CASSINI is not set
# CONFIG_NET_VENDOR_3COM is not set
CONFIG_NET_TULIP=y
# CONFIG_DE2104X is not set
# CONFIG_TULIP is not set
# CONFIG_DE4X5 is not set
# CONFIG_WINBOND_840 is not set
# CONFIG_DM9102 is not set
CONFIG_ULI526X=m
# CONFIG_HP100 is not set
# CONFIG_IBM_NEW_EMAC_ZMII is not set
# CONFIG_IBM_NEW_EMAC_RGMII is not set
# CONFIG_IBM_NEW_EMAC_TAH is not set
# CONFIG_IBM_NEW_EMAC_EMAC4 is not set
CONFIG_NET_PCI=y
# CONFIG_PCNET32 is not set
# CONFIG_AMD8111_ETH is not set
# CONFIG_ADAPTEC_STARFIRE is not set
# CONFIG_B44 is not set
# CONFIG_FORCEDETH is not set
# CONFIG_EEPRO100 is not set
CONFIG_E100=m
# CONFIG_FEALNX is not set
# CONFIG_NATSEMI is not set
# CONFIG_NE2K_PCI is not set
CONFIG_8139CP=m
CONFIG_8139TOO=m
# CONFIG_8139TOO_PIO is not set
CONFIG_8139TOO_TUNE_TWISTER=y
CONFIG_8139TOO_8129=y
# CONFIG_8139_OLD_RX_RESET is not set
CONFIG_SIS900=m
# CONFIG_EPIC100 is not set
# CONFIG_SUNDANCE is not set
# CONFIG_TLAN is not set
# CONFIG_VIA_RHINE is not set
# CONFIG_SC92031 is not set
# CONFIG_NET_POCKET is not set
CONFIG_NETDEV_1000=y
# CONFIG_ACENIC is not set
# CONFIG_DL2K is not set
CONFIG_E1000=m
CONFIG_E1000_NAPI=y
CONFIG_E1000_DISABLE_PACKET_SPLIT=y
# CONFIG_E1000E is not set
# CONFIG_NS83820 is not set
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
CONFIG_R8169=m
CONFIG_R8169_NAPI=y
CONFIG_SIS190=m
CONFIG_SKGE=m
CONFIG_SKY2=m
# CONFIG_SKY2_DEBUG is not set
# CONFIG_SK98LIN is not set
CONFIG_VIA_VELOCITY=m
CONFIG_TIGON3=m
CONFIG_BNX2=m
# CONFIG_QLA3XXX is not set
CONFIG_ATL1=m
# CONFIG_NETDEV_10000 is not set
# CONFIG_TR is not set

#
# Wireless LAN
#
# CONFIG_WLAN_PRE80211 is not set
CONFIG_WLAN_80211=y
# CONFIG_IPW2100 is not set
# CONFIG_IPW2200 is not set
# CONFIG_LIBERTAS is not set
# CONFIG_AIRO is not set
# CONFIG_HERMES is not set
# CONFIG_ATMEL is not set
# CONFIG_PRISM54 is not set
CONFIG_USB_ZD1201=m
CONFIG_RTL8187=m
# CONFIG_ADM8211 is not set
# CONFIG_P54_COMMON is not set
# CONFIG_IWLWIFI is not set
# CONFIG_HOSTAP is not set
CONFIG_BCM43XX=m
CONFIG_BCM43XX_DEBUG=y
CONFIG_BCM43XX_DMA=y
# CONFIG_BCM43XX_DMA_AND_PIO_MODE is not set
CONFIG_BCM43XX_DMA_MODE=y
# CONFIG_BCM43XX_PIO_MODE is not set
# CONFIG_B43 is not set
# CONFIG_B43LEGACY is not set
CONFIG_ZD1211RW=m
# CONFIG_ZD1211RW_DEBUG is not set
CONFIG_RT2X00=m
CONFIG_RT2X00_LIB=m
CONFIG_RT2X00_LIB_PCI=m
CONFIG_RT2X00_LIB_RFKILL=y
# CONFIG_RT2400PCI is not set
CONFIG_RT2500PCI=m
CONFIG_RT2500PCI_RFKILL=y
# CONFIG_RT61PCI is not set
# CONFIG_RT2500USB is not set
# CONFIG_RT73USB is not set
CONFIG_RT2X00_DEBUG=y

#
# USB Network Adapters
#
# CONFIG_USB_CATC is not set
# CONFIG_USB_KAWETH is not set
# CONFIG_USB_PEGASUS is not set
# CONFIG_USB_RTL8150 is not set
# CONFIG_USB_USBNET_MII is not set
# CONFIG_USB_USBNET is not set
# CONFIG_WAN is not set
# CONFIG_ATM_DRIVERS is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_PLIP is not set
CONFIG_PPP=m
CONFIG_PPP_MULTILINK=y
CONFIG_PPP_FILTER=y
CONFIG_PPP_ASYNC=m
CONFIG_PPP_SYNC_TTY=m
CONFIG_PPP_DEFLATE=m
CONFIG_PPP_BSDCOMP=m
CONFIG_PPP_MPPE=m
CONFIG_PPPOE=m
CONFIG_PPPOATM=m
# CONFIG_PPPOL2TP is not set
# CONFIG_SLIP is not set
CONFIG_SLHC=m
# CONFIG_NET_FC is not set
# CONFIG_SHAPER is not set
CONFIG_NETCONSOLE=m
CONFIG_NETCONSOLE_DYNAMIC=y
CONFIG_NETPOLL=y
# CONFIG_NETPOLL_TRAP is not set
CONFIG_NET_POLL_CONTROLLER=y
# CONFIG_ISDN is not set
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=m
CONFIG_INPUT_POLLDEV=m

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=m
# CONFIG_INPUT_TSDEV is not set
CONFIG_INPUT_EVDEV=m
CONFIG_INPUT_EVBUG=m

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_LKKBD is not set
CONFIG_KEYBOARD_XTKBD=m
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_VSXXXAA is not set
CONFIG_INPUT_JOYSTICK=y
CONFIG_JOYSTICK_ANALOG=m
CONFIG_JOYSTICK_A3D=m
CONFIG_JOYSTICK_ADI=m
CONFIG_JOYSTICK_COBRA=m
CONFIG_JOYSTICK_GF2K=m
CONFIG_JOYSTICK_GRIP=m
CONFIG_JOYSTICK_GRIP_MP=m
CONFIG_JOYSTICK_GUILLEMOT=m
CONFIG_JOYSTICK_INTERACT=m
CONFIG_JOYSTICK_SIDEWINDER=m
CONFIG_JOYSTICK_TMDC=m
CONFIG_JOYSTICK_IFORCE=m
CONFIG_JOYSTICK_IFORCE_USB=y
CONFIG_JOYSTICK_IFORCE_232=y
CONFIG_JOYSTICK_WARRIOR=m
CONFIG_JOYSTICK_MAGELLAN=m
CONFIG_JOYSTICK_SPACEORB=m
CONFIG_JOYSTICK_SPACEBALL=m
CONFIG_JOYSTICK_STINGER=m
CONFIG_JOYSTICK_TWIDJOY=m
CONFIG_JOYSTICK_DB9=m
CONFIG_JOYSTICK_GAMECON=m
CONFIG_JOYSTICK_TURBOGRAFX=m
CONFIG_JOYSTICK_JOYDUMP=m
CONFIG_JOYSTICK_XPAD=m
CONFIG_JOYSTICK_XPAD_FF=y
CONFIG_JOYSTICK_XPAD_LEDS=y
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
CONFIG_INPUT_MISC=y
CONFIG_INPUT_PCSPKR=m
# CONFIG_INPUT_WISTRON_BTNS is not set
# CONFIG_INPUT_ATLAS_BTNS is not set
# CONFIG_INPUT_ATI_REMOTE is not set
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
CONFIG_INPUT_UINPUT=m

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=m
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PARKBD is not set
CONFIG_SERIO_PCIPS2=m
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=m
CONFIG_GAMEPORT=m
CONFIG_GAMEPORT_NS558=m
# CONFIG_GAMEPORT_L4 is not set
CONFIG_GAMEPORT_EMU10K1=m
# CONFIG_GAMEPORT_FM801 is not set

#
# Character devices
#
CONFIG_VT=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
# CONFIG_SERIAL_NONSTANDARD is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=m
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=m
CONFIG_SERIAL_8250_PNP=m
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
CONFIG_SERIAL_8250_SHARE_IRQ=y
# CONFIG_SERIAL_8250_DETECT_IRQ is not set
CONFIG_SERIAL_8250_RSA=y

#
# Non-8250 serial port support
#
CONFIG_SERIAL_CORE=m
# CONFIG_SERIAL_JSM is not set
CONFIG_UNIX98_PTYS=y
# CONFIG_LEGACY_PTYS is not set
CONFIG_PRINTER=m
# CONFIG_LP_CONSOLE is not set
# CONFIG_PPDEV is not set
# CONFIG_TIPAR is not set
# CONFIG_IPMI_HANDLER is not set
# CONFIG_WATCHDOG is not set
CONFIG_HW_RANDOM=m
CONFIG_HW_RANDOM_INTEL=m
CONFIG_HW_RANDOM_AMD=m
CONFIG_HW_RANDOM_GEODE=m
CONFIG_HW_RANDOM_VIA=m
CONFIG_NVRAM=m
CONFIG_RTC=m
CONFIG_GEN_RTC=m
CONFIG_GEN_RTC_X=y
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_SONYPI is not set
CONFIG_AGP=y
CONFIG_AGP_ALI=m
# CONFIG_AGP_ATI is not set
# CONFIG_AGP_AMD is not set
CONFIG_AGP_AMD64=m
# CONFIG_AGP_INTEL is not set
# CONFIG_AGP_NVIDIA is not set
# CONFIG_AGP_SIS is not set
# CONFIG_AGP_SWORKS is not set
# CONFIG_AGP_VIA is not set
# CONFIG_AGP_EFFICEON is not set
CONFIG_DRM=m
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
# CONFIG_DRM_RADEON is not set
# CONFIG_DRM_MGA is not set
# CONFIG_DRM_SIS is not set
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
# CONFIG_MWAVE is not set
# CONFIG_PC8736x_GPIO is not set
# CONFIG_NSC_GPIO is not set
# CONFIG_CS5535_GPIO is not set
# CONFIG_RAW_DRIVER is not set
CONFIG_HPET=y
CONFIG_HPET_RTC_IRQ=y
CONFIG_HPET_MMAP=y
CONFIG_HANGCHECK_TIMER=m
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=m
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_CHARDEV=m

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=m
CONFIG_I2C_ALGOPCF=m
CONFIG_I2C_ALGOPCA=m

#
# I2C Hardware Bus support
#
CONFIG_I2C_ALI1535=m
CONFIG_I2C_ALI1563=m
CONFIG_I2C_ALI15X3=m
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
# CONFIG_I2C_I801 is not set
# CONFIG_I2C_I810 is not set
# CONFIG_I2C_PIIX4 is not set
# CONFIG_I2C_NFORCE2 is not set
CONFIG_I2C_OCORES=m
CONFIG_I2C_PARPORT=m
CONFIG_I2C_PARPORT_LIGHT=m
# CONFIG_I2C_PROSAVAGE is not set
# CONFIG_I2C_SAVAGE4 is not set
# CONFIG_I2C_SIMTEC is not set
# CONFIG_SCx200_ACB is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_TAOS_EVM is not set
# CONFIG_I2C_STUB is not set
# CONFIG_I2C_TINY_USB is not set
# CONFIG_I2C_VIA is not set
# CONFIG_I2C_VIAPRO is not set
# CONFIG_I2C_VOODOO3 is not set

#
# Miscellaneous I2C Chip support
#
# CONFIG_SENSORS_DS1337 is not set
# CONFIG_SENSORS_DS1374 is not set
# CONFIG_DS1682 is not set
# CONFIG_SENSORS_EEPROM is not set
# CONFIG_SENSORS_PCF8574 is not set
# CONFIG_SENSORS_PCA9539 is not set
# CONFIG_SENSORS_PCF8591 is not set
# CONFIG_SENSORS_MAX6875 is not set
# CONFIG_SENSORS_TSL2550 is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_I2C_DEBUG_CHIP is not set

#
# SPI support
#
# CONFIG_SPI is not set
# CONFIG_SPI_MASTER is not set
# CONFIG_W1 is not set
# CONFIG_POWER_SUPPLY is not set
CONFIG_HWMON=m
CONFIG_HWMON_VID=m
# CONFIG_SENSORS_ABITUGURU is not set
# CONFIG_SENSORS_ABITUGURU3 is not set
# CONFIG_SENSORS_AD7418 is not set
# CONFIG_SENSORS_ADM1021 is not set
# CONFIG_SENSORS_ADM1025 is not set
# CONFIG_SENSORS_ADM1026 is not set
# CONFIG_SENSORS_ADM1029 is not set
# CONFIG_SENSORS_ADM1031 is not set
# CONFIG_SENSORS_ADM9240 is not set
CONFIG_SENSORS_K8TEMP=m
# CONFIG_SENSORS_ASB100 is not set
# CONFIG_SENSORS_ATXP1 is not set
# CONFIG_SENSORS_DS1621 is not set
# CONFIG_SENSORS_F71805F is not set
# CONFIG_SENSORS_FSCHER is not set
# CONFIG_SENSORS_FSCPOS is not set
# CONFIG_SENSORS_GL518SM is not set
# CONFIG_SENSORS_GL520SM is not set
# CONFIG_SENSORS_CORETEMP is not set
CONFIG_SENSORS_IT87=m
# CONFIG_SENSORS_LM63 is not set
# CONFIG_SENSORS_LM75 is not set
# CONFIG_SENSORS_LM77 is not set
# CONFIG_SENSORS_LM78 is not set
# CONFIG_SENSORS_LM80 is not set
# CONFIG_SENSORS_LM83 is not set
# CONFIG_SENSORS_LM85 is not set
# CONFIG_SENSORS_LM87 is not set
# CONFIG_SENSORS_LM90 is not set
# CONFIG_SENSORS_LM92 is not set
# CONFIG_SENSORS_LM93 is not set
# CONFIG_SENSORS_MAX1619 is not set
# CONFIG_SENSORS_MAX6650 is not set
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_DME1737 is not set
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SMSC47M192 is not set
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_THMC50 is not set
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83781D is not set
# CONFIG_SENSORS_W83791D is not set
# CONFIG_SENSORS_W83792D is not set
# CONFIG_SENSORS_W83793 is not set
# CONFIG_SENSORS_W83L785TS is not set
# CONFIG_SENSORS_W83627HF is not set
CONFIG_SENSORS_W83627EHF=m
# CONFIG_SENSORS_HDAPS is not set
# CONFIG_SENSORS_APPLESMC is not set
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Sonics Silicon Backplane
#
CONFIG_SSB_POSSIBLE=y
# CONFIG_SSB is not set

#
# Multifunction device drivers
#
# CONFIG_MFD_SM501 is not set

#
# Multimedia devices
#
# CONFIG_VIDEO_DEV is not set
# CONFIG_DVB_CORE is not set
# CONFIG_DAB is not set

#
# Graphics support
#
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=m
CONFIG_BACKLIGHT_CLASS_DEVICE=m
# CONFIG_BACKLIGHT_CORGI is not set
# CONFIG_BACKLIGHT_PROGEAR is not set

#
# Display device support
#
# CONFIG_DISPLAY_SUPPORT is not set
CONFIG_VGASTATE=m
CONFIG_VIDEO_OUTPUT_CONTROL=m
CONFIG_FB=m
# CONFIG_FIRMWARE_EDID is not set
CONFIG_FB_DDC=m
CONFIG_FB_CFB_FILLRECT=m
CONFIG_FB_CFB_COPYAREA=m
CONFIG_FB_CFB_IMAGEBLIT=m
# CONFIG_FB_SYS_FILLRECT is not set
# CONFIG_FB_SYS_COPYAREA is not set
# CONFIG_FB_SYS_IMAGEBLIT is not set
# CONFIG_FB_SYS_FOPS is not set
CONFIG_FB_DEFERRED_IO=y
# CONFIG_FB_SVGALIB is not set
# CONFIG_FB_MACMODES is not set
CONFIG_FB_BACKLIGHT=y
CONFIG_FB_MODE_HELPERS=y
# CONFIG_FB_TILEBLITTING is not set

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_HECUBA is not set
# CONFIG_FB_HGA is not set
# CONFIG_FB_S1D13XXX is not set
CONFIG_FB_NVIDIA=m
CONFIG_FB_NVIDIA_I2C=y
# CONFIG_FB_NVIDIA_DEBUG is not set
CONFIG_FB_NVIDIA_BACKLIGHT=y
# CONFIG_FB_RIVA is not set
# CONFIG_FB_I810 is not set
# CONFIG_FB_LE80578 is not set
# CONFIG_FB_INTEL is not set
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_CYBLA is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_GEODE is not set
# CONFIG_FB_VIRTUAL is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
# CONFIG_VGACON_SOFT_SCROLLBACK is not set
CONFIG_VIDEO_SELECT=y
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=m
# CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY is not set
# CONFIG_FRAMEBUFFER_CONSOLE_ROTATION is not set
CONFIG_FONTS=y
# CONFIG_FONT_8x8 is not set
CONFIG_FONT_8x16=y
# CONFIG_FONT_6x11 is not set
# CONFIG_FONT_7x14 is not set
# CONFIG_FONT_PEARL_8x8 is not set
# CONFIG_FONT_ACORN_8x8 is not set
# CONFIG_FONT_MINI_4x6 is not set
# CONFIG_FONT_SUN8x16 is not set
# CONFIG_FONT_SUN12x22 is not set
# CONFIG_FONT_10x18 is not set
CONFIG_LOGO=y
# CONFIG_LOGO_LINUX_MONO is not set
CONFIG_LOGO_LINUX_VGA16=y
CONFIG_LOGO_LINUX_CLUT224=y

#
# Sound
#
CONFIG_SOUND=m

#
# Advanced Linux Sound Architecture
#
CONFIG_SND=m
CONFIG_SND_TIMER=m
CONFIG_SND_PCM=m
CONFIG_SND_HWDEP=m
CONFIG_SND_RAWMIDI=m
CONFIG_SND_SEQUENCER=m
CONFIG_SND_SEQ_DUMMY=m
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=m
CONFIG_SND_PCM_OSS=m
CONFIG_SND_PCM_OSS_PLUGINS=y
CONFIG_SND_SEQUENCER_OSS=y
CONFIG_SND_RTCTIMER=m
CONFIG_SND_SEQ_RTCTIMER_DEFAULT=y
# CONFIG_SND_DYNAMIC_MINORS is not set
CONFIG_SND_SUPPORT_OLD_API=y
# CONFIG_SND_VERBOSE_PROCFS is not set
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set

#
# Generic devices
#
CONFIG_SND_MPU401_UART=m
CONFIG_SND_OPL3_LIB=m
CONFIG_SND_AC97_CODEC=m
CONFIG_SND_DUMMY=m
CONFIG_SND_VIRMIDI=m
# CONFIG_SND_MTPAV is not set
# CONFIG_SND_MTS64 is not set
# CONFIG_SND_SERIAL_U16550 is not set
CONFIG_SND_MPU401=m
# CONFIG_SND_PORTMAN2X4 is not set
CONFIG_SND_SB_COMMON=m
CONFIG_SND_SB16_DSP=m

#
# PCI devices
#
# CONFIG_SND_AD1889 is not set
# CONFIG_SND_ALS300 is not set
# CONFIG_SND_ALS4000 is not set
CONFIG_SND_ALI5451=m
# CONFIG_SND_ATIIXP is not set
# CONFIG_SND_ATIIXP_MODEM is not set
# CONFIG_SND_AU8810 is not set
# CONFIG_SND_AU8820 is not set
# CONFIG_SND_AU8830 is not set
# CONFIG_SND_AZT3328 is not set
# CONFIG_SND_BT87X is not set
CONFIG_SND_CA0106=m
CONFIG_SND_CMIPCI=m
CONFIG_SND_CS4281=m
CONFIG_SND_CS46XX=m
CONFIG_SND_CS46XX_NEW_DSP=y
CONFIG_SND_CS5530=m
CONFIG_SND_CS5535AUDIO=m
# CONFIG_SND_DARLA20 is not set
# CONFIG_SND_GINA20 is not set
# CONFIG_SND_LAYLA20 is not set
# CONFIG_SND_DARLA24 is not set
# CONFIG_SND_GINA24 is not set
# CONFIG_SND_LAYLA24 is not set
# CONFIG_SND_MONA is not set
# CONFIG_SND_MIA is not set
# CONFIG_SND_ECHO3G is not set
# CONFIG_SND_INDIGO is not set
# CONFIG_SND_INDIGOIO is not set
# CONFIG_SND_INDIGODJ is not set
CONFIG_SND_EMU10K1=m
CONFIG_SND_EMU10K1X=m
CONFIG_SND_ENS1370=m
CONFIG_SND_ENS1371=m
# CONFIG_SND_ES1938 is not set
# CONFIG_SND_ES1968 is not set
# CONFIG_SND_FM801 is not set
CONFIG_SND_HDA_INTEL=m
# CONFIG_SND_HDSP is not set
# CONFIG_SND_HDSPM is not set
# CONFIG_SND_ICE1712 is not set
# CONFIG_SND_ICE1724 is not set
CONFIG_SND_INTEL8X0=m
CONFIG_SND_INTEL8X0M=m
# CONFIG_SND_KORG1212 is not set
# CONFIG_SND_MAESTRO3 is not set
# CONFIG_SND_MIXART is not set
# CONFIG_SND_NM256 is not set
# CONFIG_SND_PCXHR is not set
# CONFIG_SND_RIPTIDE is not set
# CONFIG_SND_RME32 is not set
# CONFIG_SND_RME96 is not set
# CONFIG_SND_RME9652 is not set
# CONFIG_SND_SONICVIBES is not set
# CONFIG_SND_TRIDENT is not set
# CONFIG_SND_VIA82XX is not set
# CONFIG_SND_VIA82XX_MODEM is not set
# CONFIG_SND_VX222 is not set
# CONFIG_SND_YMFPCI is not set
# CONFIG_SND_AC97_POWER_SAVE is not set

#
# USB devices
#
# CONFIG_SND_USB_AUDIO is not set
# CONFIG_SND_USB_USX2Y is not set
# CONFIG_SND_USB_CAIAQ is not set

#
# System on Chip audio support
#
# CONFIG_SND_SOC is not set

#
# SoC Audio support for SuperH
#

#
# Open Sound System
#
# CONFIG_SOUND_PRIME is not set
CONFIG_AC97_BUS=m
CONFIG_HID_SUPPORT=y
CONFIG_HID=y
# CONFIG_HID_DEBUG is not set

#
# USB Input Devices
#
CONFIG_USB_HID=m
# CONFIG_USB_HIDINPUT_POWERBOOK is not set
CONFIG_HID_FF=y
CONFIG_HID_PID=y
CONFIG_LOGITECH_FF=y
# CONFIG_PANTHERLORD_FF is not set
CONFIG_THRUSTMASTER_FF=y
CONFIG_ZEROPLUS_FF=y
CONFIG_USB_HIDDEV=y

#
# USB HID Boot Protocol drivers
#
CONFIG_USB_KBD=m
CONFIG_USB_MOUSE=m
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=m
# CONFIG_USB_DEBUG is not set

#
# Miscellaneous USB options
#
CONFIG_USB_DEVICEFS=y
CONFIG_USB_DEVICE_CLASS=y
# CONFIG_USB_DYNAMIC_MINORS is not set
# CONFIG_USB_SUSPEND is not set
# CONFIG_USB_PERSIST is not set
# CONFIG_USB_OTG is not set

#
# USB Host Controller Drivers
#
CONFIG_USB_EHCI_HCD=m
CONFIG_USB_EHCI_SPLIT_ISO=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
# CONFIG_USB_ISP116X_HCD is not set
CONFIG_USB_OHCI_HCD=m
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
# CONFIG_USB_UHCI_HCD is not set
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set

#
# USB Device Class drivers
#
CONFIG_USB_ACM=m
CONFIG_USB_PRINTER=m

#
# NOTE: USB_STORAGE enables SCSI, and 'SCSI disk support'
#

#
# may also be needed; see USB_STORAGE Help for more information
#
CONFIG_USB_STORAGE=m
# CONFIG_USB_STORAGE_DEBUG is not set
CONFIG_USB_STORAGE_DATAFAB=y
CONFIG_USB_STORAGE_FREECOM=y
CONFIG_USB_STORAGE_DPCM=y
CONFIG_USB_STORAGE_USBAT=y
CONFIG_USB_STORAGE_SDDR09=y
CONFIG_USB_STORAGE_SDDR55=y
CONFIG_USB_STORAGE_JUMPSHOT=y
CONFIG_USB_STORAGE_ALAUDA=y
CONFIG_USB_STORAGE_KARMA=y
CONFIG_USB_LIBUSUAL=y

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
# CONFIG_USB_MICROTEK is not set
CONFIG_USB_MON=y

#
# USB port drivers
#
# CONFIG_USB_USS720 is not set

#
# USB Serial Converter support
#
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
# CONFIG_USB_EMI26 is not set
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_AUERSWALD is not set
# CONFIG_USB_RIO500 is not set
# CONFIG_USB_LEGOTOWER is not set
# CONFIG_USB_LCD is not set
# CONFIG_USB_BERRY_CHARGE is not set
CONFIG_USB_LED=m
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_PHIDGET is not set
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
# CONFIG_USB_APPLEDISPLAY is not set
# CONFIG_USB_SISUSBVGA is not set
CONFIG_USB_LD=m
CONFIG_USB_TRANCEVIBRATOR=m
# CONFIG_USB_IOWARRIOR is not set
# CONFIG_USB_TEST is not set

#
# USB DSL modem support
#
CONFIG_USB_ATM=m
CONFIG_USB_SPEEDTOUCH=m
# CONFIG_USB_CXACRU is not set
# CONFIG_USB_UEAGLEATM is not set
# CONFIG_USB_XUSBATM is not set

#
# USB Gadget Support
#
# CONFIG_USB_GADGET is not set
# CONFIG_MMC is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=m

#
# LED drivers
#

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=m
CONFIG_LEDS_TRIGGER_HEARTBEAT=m
# CONFIG_INFINIBAND is not set
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=m
CONFIG_RTC_CLASS=m

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
CONFIG_RTC_INTF_DEV_UIE_EMUL=y
CONFIG_RTC_DRV_TEST=m

#
# I2C RTC drivers
#
CONFIG_RTC_DRV_DS1307=m
CONFIG_RTC_DRV_DS1672=m
CONFIG_RTC_DRV_MAX6900=m
CONFIG_RTC_DRV_RS5C372=m
CONFIG_RTC_DRV_ISL1208=m
CONFIG_RTC_DRV_X1205=m
CONFIG_RTC_DRV_PCF8563=m
CONFIG_RTC_DRV_PCF8583=m
# CONFIG_RTC_DRV_M41T80 is not set

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=m
CONFIG_RTC_DRV_DS1553=m
# CONFIG_RTC_DRV_STK17TA8 is not set
CONFIG_RTC_DRV_DS1742=m
CONFIG_RTC_DRV_M48T86=m
# CONFIG_RTC_DRV_M48T59 is not set
CONFIG_RTC_DRV_V3020=m

#
# on-CPU RTC drivers
#

#
# DMA Engine support
#
# CONFIG_DMA_ENGINE is not set

#
# DMA Clients
#

#
# DMA Devices
#
# CONFIG_AUXDISPLAY is not set
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=m
# CONFIG_KVM_INTEL is not set
CONFIG_KVM_AMD=m

#
# Userspace I/O
#
# CONFIG_UIO is not set

#
# File systems
#
CONFIG_EXT2_FS=m
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
CONFIG_EXT2_FS_SECURITY=y
CONFIG_EXT2_FS_XIP=y
CONFIG_FS_XIP=y
CONFIG_EXT3_FS=y
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
# CONFIG_EXT4DEV_FS is not set
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
CONFIG_JFS_FS=m
CONFIG_JFS_POSIX_ACL=y
# CONFIG_JFS_SECURITY is not set
# CONFIG_JFS_DEBUG is not set
CONFIG_JFS_STATISTICS=y
CONFIG_FS_POSIX_ACL=y
# CONFIG_XFS_FS is not set
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_ROMFS_FS is not set
CONFIG_INOTIFY=y
CONFIG_INOTIFY_USER=y
# CONFIG_QUOTA is not set
CONFIG_DNOTIFY=y
# CONFIG_AUTOFS_FS is not set
# CONFIG_AUTOFS4_FS is not set
CONFIG_FUSE_FS=m

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=m
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
CONFIG_UDF_FS=m
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=m
CONFIG_MSDOS_FS=m
CONFIG_VFAT_FS=m
CONFIG_FAT_DEFAULT_CODEPAGE=850
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
CONFIG_NTFS_FS=m
# CONFIG_NTFS_DEBUG is not set
CONFIG_NTFS_RW=y

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
# CONFIG_TMPFS_POSIX_ACL is not set
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_RAMFS=y
CONFIG_CONFIGFS_FS=m

#
# Miscellaneous filesystems
#
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
CONFIG_ECRYPT_FS=m
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
CONFIG_CRAMFS=y
# CONFIG_VXFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set

#
# Network File Systems
#
# CONFIG_NFS_FS is not set
# CONFIG_NFSD is not set
# CONFIG_SMB_FS is not set
CONFIG_CIFS=m
CONFIG_CIFS_STATS=y
# CONFIG_CIFS_STATS2 is not set
CONFIG_CIFS_WEAK_PW_HASH=y
CONFIG_CIFS_XATTR=y
CONFIG_CIFS_POSIX=y
# CONFIG_CIFS_DEBUG2 is not set
# CONFIG_CIFS_EXPERIMENTAL is not set
# CONFIG_NCP_FS is not set
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set
CONFIG_9P_FS=m

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
# CONFIG_OSF_PARTITION is not set
# CONFIG_AMIGA_PARTITION is not set
# CONFIG_ATARI_PARTITION is not set
# CONFIG_MAC_PARTITION is not set
CONFIG_MSDOS_PARTITION=y
# CONFIG_BSD_DISKLABEL is not set
# CONFIG_MINIX_SUBPARTITION is not set
# CONFIG_SOLARIS_X86_PARTITION is not set
# CONFIG_UNIXWARE_DISKLABEL is not set
CONFIG_LDM_PARTITION=y
CONFIG_LDM_DEBUG=y
# CONFIG_SGI_PARTITION is not set
# CONFIG_ULTRIX_PARTITION is not set
# CONFIG_SUN_PARTITION is not set
CONFIG_KARMA_PARTITION=y
CONFIG_EFI_PARTITION=y
# CONFIG_SYSV68_PARTITION is not set

#
# Native Language Support
#
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="cp850"
# CONFIG_NLS_CODEPAGE_437 is not set
# CONFIG_NLS_CODEPAGE_737 is not set
# CONFIG_NLS_CODEPAGE_775 is not set
CONFIG_NLS_CODEPAGE_850=m
# CONFIG_NLS_CODEPAGE_852 is not set
# CONFIG_NLS_CODEPAGE_855 is not set
# CONFIG_NLS_CODEPAGE_857 is not set
CONFIG_NLS_CODEPAGE_860=m
# CONFIG_NLS_CODEPAGE_861 is not set
# CONFIG_NLS_CODEPAGE_862 is not set
# CONFIG_NLS_CODEPAGE_863 is not set
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
# CONFIG_NLS_CODEPAGE_866 is not set
# CONFIG_NLS_CODEPAGE_869 is not set
# CONFIG_NLS_CODEPAGE_936 is not set
# CONFIG_NLS_CODEPAGE_950 is not set
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
# CONFIG_NLS_CODEPAGE_874 is not set
# CONFIG_NLS_ISO8859_8 is not set
# CONFIG_NLS_CODEPAGE_1250 is not set
# CONFIG_NLS_CODEPAGE_1251 is not set
# CONFIG_NLS_ASCII is not set
CONFIG_NLS_ISO8859_1=m
# CONFIG_NLS_ISO8859_2 is not set
CONFIG_NLS_ISO8859_3=m
# CONFIG_NLS_ISO8859_4 is not set
# CONFIG_NLS_ISO8859_5 is not set
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
CONFIG_NLS_ISO8859_14=m
CONFIG_NLS_ISO8859_15=m
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
CONFIG_NLS_UTF8=m

#
# Distributed Lock Manager
#
# CONFIG_DLM is not set
# CONFIG_INSTRUMENTATION is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_MAGIC_SYSRQ=y
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_SHIRQ=y
CONFIG_DETECT_SOFTLOCKUP=y
# CONFIG_SCHED_DEBUG is not set
# CONFIG_SCHEDSTATS is not set
# CONFIG_TIMER_STATS is not set
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_DEBUG_PREEMPT is not set
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
# CONFIG_DEBUG_SPINLOCK is not set
# CONFIG_DEBUG_MUTEXES is not set
# CONFIG_DEBUG_LOCK_ALLOC is not set
# CONFIG_PROVE_LOCKING is not set
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_SPINLOCK_SLEEP is not set
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
# CONFIG_DEBUG_KOBJECT is not set
# CONFIG_DEBUG_HIGHMEM is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_INFO is not set
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_LIST is not set
# CONFIG_FRAME_POINTER is not set
# CONFIG_FORCED_INLINING is not set
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_FAULT_INJECTION is not set
CONFIG_EARLY_PRINTK=y
# CONFIG_DEBUG_STACKOVERFLOW is not set
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_PAGEALLOC is not set
# CONFIG_DEBUG_RODATA is not set
CONFIG_4KSTACKS=y
CONFIG_X86_FIND_SMP_CONFIG=y
CONFIG_X86_MPPARSE=y
CONFIG_DOUBLEFAULT=y

#
# Security options
#
CONFIG_KEYS=y
CONFIG_KEYS_DEBUG_PROC_KEYS=y
CONFIG_SECURITY=y
CONFIG_SECURITY_NETWORK=y
CONFIG_SECURITY_NETWORK_XFRM=y
CONFIG_SECURITY_CAPABILITIES=y
# CONFIG_SECURITY_ROOTPLUG is not set
CONFIG_XOR_BLOCKS=m
CONFIG_ASYNC_CORE=m
CONFIG_ASYNC_MEMCPY=m
CONFIG_ASYNC_XOR=m
CONFIG_CRYPTO=y
CONFIG_CRYPTO_ALGAPI=m
CONFIG_CRYPTO_ABLKCIPHER=m
CONFIG_CRYPTO_AEAD=m
CONFIG_CRYPTO_BLKCIPHER=m
CONFIG_CRYPTO_HASH=m
CONFIG_CRYPTO_MANAGER=m
CONFIG_CRYPTO_HMAC=m
CONFIG_CRYPTO_XCBC=m
CONFIG_CRYPTO_NULL=m
CONFIG_CRYPTO_MD4=m
CONFIG_CRYPTO_MD5=m
CONFIG_CRYPTO_SHA1=m
CONFIG_CRYPTO_SHA256=m
CONFIG_CRYPTO_SHA512=m
CONFIG_CRYPTO_WP512=m
CONFIG_CRYPTO_TGR192=m
CONFIG_CRYPTO_GF128MUL=m
CONFIG_CRYPTO_ECB=m
CONFIG_CRYPTO_CBC=m
CONFIG_CRYPTO_PCBC=m
CONFIG_CRYPTO_LRW=m
CONFIG_CRYPTO_XTS=m
CONFIG_CRYPTO_CRYPTD=m
CONFIG_CRYPTO_DES=m
CONFIG_CRYPTO_FCRYPT=m
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_TWOFISH=m
CONFIG_CRYPTO_TWOFISH_COMMON=m
CONFIG_CRYPTO_TWOFISH_586=m
CONFIG_CRYPTO_SERPENT=m
CONFIG_CRYPTO_AES=m
CONFIG_CRYPTO_AES_586=m
CONFIG_CRYPTO_CAST5=m
CONFIG_CRYPTO_CAST6=m
CONFIG_CRYPTO_TEA=m
CONFIG_CRYPTO_ARC4=m
CONFIG_CRYPTO_KHAZAD=m
CONFIG_CRYPTO_ANUBIS=m
CONFIG_CRYPTO_SEED=m
CONFIG_CRYPTO_DEFLATE=m
CONFIG_CRYPTO_MICHAEL_MIC=m
CONFIG_CRYPTO_CRC32C=m
CONFIG_CRYPTO_CAMELLIA=m
CONFIG_CRYPTO_TEST=m
CONFIG_CRYPTO_AUTHENC=m
# CONFIG_CRYPTO_HW is not set

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_CRC_CCITT=m
CONFIG_CRC16=m
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
CONFIG_CRC7=m
CONFIG_LIBCRC32C=m
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=m
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=m
CONFIG_TEXTSEARCH_BM=m
CONFIG_TEXTSEARCH_FSM=m
CONFIG_PLIST=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_X86_SMP=y
CONFIG_X86_HT=y
CONFIG_X86_BIOS_REBOOT=y
CONFIG_X86_TRAMPOLINE=y
CONFIG_KTIME_SCALAR=y


-- 
Nunca discutas con un idiota. Al final te hacen rebajarte a su nivel y entonces
te acaban ganando debido a su mayor experiencia.

